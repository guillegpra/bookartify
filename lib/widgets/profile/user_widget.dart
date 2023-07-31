import 'package:bookartify/services/database_api.dart';
import 'package:bookartify/widgets/profile/user_counter.dart';
import 'package:bookartify/widgets/profile/user_display.dart';
import 'package:flutter/material.dart';
import 'package:bookartify/screens/following_list.dart';

class UserWidget extends StatefulWidget {
  final String userId;
  final String username;
  final String profileImageUrl;

  const UserWidget({
    Key? key,
    required this.userId,
    required this.username,
    required this.profileImageUrl,
  }) : super(key: key);

  @override
  _UserWidgetState createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  int? _artWorksCountData;
  int? _followingCountData;

  @override
  void initState() {
    super.initState();
    _loadArtCountData();
    _loadFollowingCountData();
  }

  Future<void> _loadArtCountData() async {
    try {
      int artCount = await getArtCountByUser(widget.userId);
      int coversCount = await getCoversCountByUser(widget.userId);
      setState(() {
        _artWorksCountData = artCount + coversCount;
      });
    } catch (e) {
      print("Error loading artworks count: $e");
    }
  }

  Future<void> _loadFollowingCountData() async {
    try {
      int following = await getFollowingCountByUser(widget.userId);
      setState(() {
        _followingCountData = following;
      });
    } catch (e) {
      print("Error loading following count: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xff2f2f2f),
                  width: 2.0, // Width of the border
                ),
              ),
              child: CircleAvatar(
                radius: 40,
                backgroundImage: widget.profileImageUrl.isNotEmpty
                    ? NetworkImage(widget.profileImageUrl) as ImageProvider
                    : const AssetImage("images/upload-images-placeholder.png")
                        as ImageProvider,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                if (_artWorksCountData != null)
                  GestureDetector(
                    onTap: () {
                      _navigateToFollowingListScreen();
                    },
                    child: UserCounter(
                      name: "Artworks",
                      number: _artWorksCountData!,
                    ),
                  )
                else
                  const UserCounter(name: "Artworks", number: 0),
                const SizedBox(width: 10),
                if (_followingCountData != null)
                  GestureDetector(
                    onTap: () {
                      _navigateToFollowingListScreen();
                    },
                    child: UserCounter(
                      name: "Following",
                      number: _followingCountData!,
                    ),
                  )
                else
                  const UserCounter(name: "Following", number: 0),
              ],
            ),
          ],
        ),
        UserDisplay(
          userId: widget.userId,
          username: widget.username,
        ),
      ],
    );
  }

  void _navigateToFollowingListScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FollowingListScreen(),
      ),
    );
  }
}
