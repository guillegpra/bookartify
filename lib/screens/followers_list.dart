import 'package:bookartify/screens/profile_screen.dart';
import 'package:bookartify/services/database_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FollowersListScreen extends StatefulWidget {
  final String userId;

  const FollowersListScreen({super.key, required this.userId});

  @override
  State<FollowersListScreen> createState() => _FollowersListScreenState();
}

class _FollowersListScreenState extends State<FollowersListScreen> {
  List<dynamic> _followers = [];
  List<String> _followersUsernames = [];
  List<String> _followersPics = [];
  List<bool> _isFollowingUserList = [];

  @override
  void initState() {
    super.initState();
    _fetchFollowersList();
  }

  Future<void> _fetchFollowersList() async {
    try {
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;

      List<dynamic> followers =
        await getFollowersByUser(widget.userId);
      List<dynamic> followerIds =
        followers.map((artist) => artist["user_id"]).toList();

      List<bool> isFollowingUserList = [];

      print("Followers IDs: $followerIds");

      List<String> usernames = [];
      List<String> profilePics = [];
      for (String followerId in followerIds) {
        Map<String, dynamic> user = await getUserById(followerId);
        if (user != null) {
          usernames.add(user["username"] ?? "");
          profilePics.add(user["profile_pic_url"] ?? "");
        }

        // check if current user is following them
        bool isFollowingArtistAux = await isFollowingUser(currentUserId, followerId);
        isFollowingUserList.add(isFollowingArtistAux);
      }

      setState(() {
        _followers = followerIds;
        _followersUsernames = usernames;
        _followersPics = profilePics;
        _isFollowingUserList = isFollowingUserList;
      });
    } catch (e) {
      print("Error fetching following artists: $e");
    }
  }

  void _toggleFollowingUser(bool isFollowing, String userId, int index) async {
    // Get the current user's ID
    String currentUserID = FirebaseAuth.instance.currentUser!.uid;

    try {
      if (isFollowing) {
        await unfollowUser(currentUserID, userId);
        print("Unfollowed user response: Success");
      } else {
        await followUser(currentUserID, userId);
        print("Followed user response: Success");
      }

      // Toggle the icon state after successful follow/unfollow
      setState(() {
        _isFollowingUserList[index] = !_isFollowingUserList[index];
      });
    } catch (e) {
      // Handle any errors that occur during the operation
      print("Error saving/unfollowing user: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Followers",
          style: GoogleFonts.dmSerifDisplay(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _fetchFollowersList();
          _buildFollowersList();
        },
        child: _buildFollowersList(),
      ),
    );
  }

  Widget _buildFollowersList() {
    if (_followers.isEmpty) {
      return const Center(child: Text("No followers yet."),);
    }

    return ListView.builder(
      itemCount: _followers.length,
      itemBuilder: (context, index) {
        String userId = _followers[index];
        String username = _followersUsernames[index];
        String profilePic = _followersPics[index];
        bool isFollowing = _isFollowingUserList[index];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(42),
              color: const Color.fromARGB(70, 192, 162, 73),
            ),
            child: ListTile(
              leading: CircleAvatar(
                radius: 24,
                backgroundImage: profilePic == ""
                    ? const AssetImage("images/upload-images-placeholder.png")
                        as ImageProvider
                    : NetworkImage(profilePic),
              ),
              title: GestureDetector(
                onTap: () {
                  _navigateToUserProfileScreen(userId);
                },
                child: Text(
                  username,
                  style: GoogleFonts.dmSerifDisplay(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              trailing: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: GestureDetector(
                  onTap: () {
                    _toggleFollowingUser(isFollowing, userId, index);
                  },
                  child: Icon(
                    isFollowing ? Icons.check : Icons.add,
                    size: 30,
                    color: isFollowing
                        ? const Color(0xFFBFA054)
                        : const Color(0xFF2F2F2F),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _navigateToUserProfileScreen(String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(userId: userId),
      ),
    );
  }
}
