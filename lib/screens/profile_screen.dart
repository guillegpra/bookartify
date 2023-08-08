import 'dart:io';

import 'package:bookartify/screens/followers_list.dart';
import 'package:bookartify/services/database_api.dart';
import 'package:bookartify/services/register.dart';
import 'package:bookartify/widgets/image_grid.dart';
import 'package:bookartify/widgets/keep_alive_wrapper.dart';
import 'package:bookartify/widgets/profile/user_widget.dart';
import 'package:bookartify/widgets/profile/edit_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;
  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with
        TickerProviderStateMixin,
        AutomaticKeepAliveClientMixin<ProfileScreen> {
  late TabController _tabController;
  User? currentUser;
  Map<String, dynamic> _userData = {};
  List<dynamic> _bookart = [];
  List<dynamic> _covers = [];
  List<dynamic> _bookmarks = [];
  int _followers = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    currentUser = FirebaseAuth.instance.currentUser;
    _fetchUserData();
    _fetchFollowersCount();
    _fetchBookart();
    _fetchCovers();
    _fetchBookmarks();
  }

  Future<void> _fetchUserData() async {
    Map<String, dynamic> data = await getUserById(widget.userId);
    getUsernameById(widget.userId);
    print(data.toString());
    setState(() {
      _userData = data;
    });
  }

  Future<void> _fetchBookart() async {
    List<dynamic> fetchedBookart = await getArtByUser(widget.userId);
    setState(() {
      _bookart = fetchedBookart;
    });
  }

  Future<void> _fetchCovers() async {
    List<dynamic> fetchedCovers = await getCoversByUser(widget.userId);
    setState(() {
      _covers = fetchedCovers;
    });
  }

  Future<void> _fetchBookmarks() async {
    List<dynamic> fetchedBookmarks = await getBookmarksByUser(widget.userId);
    setState(() {
      _bookmarks = fetchedBookmarks;
    });
  }

  Future<void> _fetchFollowersCount() async {
    int fetchedCount = await getFollowersCountByUser(widget.userId);
    setState(() {
      _followers = fetchedCount;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _reloadData() async {
    // Fetch the data again and update the state
    await _fetchUserData();
    await _fetchFollowersCount();
    await _fetchBookart();
    await _fetchCovers();
    await _fetchBookmarks();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      // Persistent AppBar that never scrolls
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        title: Text(
          _userData["username"] ?? "username",
          style: GoogleFonts.dmSerifDisplay(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Visibility(
            visible: widget.userId == currentUser!.uid,
            child: PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                    value: "followers",
                    child: Text("Followers: $_followers"),
                  ),
                  const PopupMenuItem(
                    value: "edit",
                    child: Text("Edit profile"),
                  ),
                  const PopupMenuItem(
                    value: "change_pwd",
                    child: Text("Change password"),
                  ),
                  const PopupMenuItem(
                    value: "logout",
                    child: Text("Logout"),
                  ),
                ];
              },
              onSelected: (value) {
                // Handle selected option
                switch (value) {
                  case "followers":
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FollowersListScreen(userId: FirebaseAuth.instance.currentUser!.uid)
                      ),
                    );
                    break;
                  case "edit":
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                          EditProfileScreen(
                            userId: widget.userId,
                          ),
                      ),
                    );
                    break;
                  case "change_pwd":
                    // TODO
                    break;
                  case "logout":
                    // TODO
                    signOut(context);
                    break;
                  default:
                    print("Error");
                }
              },
              icon: const Icon(Icons.more_vert),
            ),
          ),
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: RefreshIndicator(
          notificationPredicate: (notification) {
            // with NestedScrollView local(depth == 2) OverscrollNotification are not sent
            if (notification is OverscrollNotification || Platform.isIOS) {
              return notification.depth == 2;
            }
            return notification.depth == 0;
          },
          onRefresh: _reloadData,
          child: NestedScrollView(
            // allows you to build a list of elements that would be scrolled away till the
            // body reached the top
            headerSliverBuilder: (context, _) {
              return [
                SliverToBoxAdapter(
                  child: UserWidget(
                    userId: widget.userId,
                    username: _userData["username"] ?? "username",
                    bio: _userData["bio"] ?? "Hi there!",
                    goodreadsUrl: _userData["goodreads_url"] ?? "",
                    profileImageUrl: _userData["profile_pic_url"] ?? "", // Pass the profile image URL
                  ),
                ),
              ];
            },
            body: Column(
              children: <Widget>[
                const TabBar(
                    indicatorColor: Color(0xFF8A6245),
                    // labelStyle: GoogleFonts.poppins(),
                    tabs: [
                      Tab(text: 'Bookart'),
                      Tab(text: 'Covers'),
                      Tab(text: 'Collections'),
                    ]),
                Expanded(
                    child: TabBarView(
                  children: [
                    // ------ Bookart content ------
                    KeepAliveWrapper(
                      key: const ValueKey(0),
                      child: ImageGrid(
                        types: List.filled(_bookart.length, "art"),
                        posts: _bookart,
                      ),
                    ),
                    // ------ Covers content ------
                    KeepAliveWrapper(
                      key: const ValueKey(1),
                      child: ImageGrid(
                        types: List.filled(_covers.length, "cover"),
                        posts: _covers,
                      ),
                    ),
                    // ------ Collections content ------
                    KeepAliveWrapper(
                      key: const ValueKey(2),
                      child: ImageGrid(
                        types: _bookmarks.map((e) => e["type"].toString()).toList(),
                        posts: _bookmarks,
                      ),
                    ),
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
