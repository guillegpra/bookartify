import 'package:bookartify/services/database_api.dart';
import 'package:bookartify/services/register.dart';
import 'package:bookartify/services/usernames_db.dart';
import 'package:bookartify/services/user_profile_pics_db.dart';
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
  String _username = "";
  String _profileImageUrl = ""; // New variable for profile image URL
  List<dynamic> _bookart = [];
  List<dynamic> _covers = [];
  List<dynamic> _bookmarks = [];
  int _followers = 0;
  bool _showUsernameInAppBar = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    currentUser = FirebaseAuth.instance.currentUser;
    _fetchUsername();
    _fetchProfileImageUrl(); // Fetch profile image URL
    _fetchFollowersCount();
    _fetchBookart();
    _fetchCovers();
    _fetchBookmarks();
  }

  Future<void> _fetchProfileImageUrl() async {
    String? fetchedImageUrl = await getUserProfilePic(
        widget.userId); // Use your function to get the profile pic
    setState(() {
      _profileImageUrl = fetchedImageUrl ?? "";
    });
  }

  Future<void> _fetchUsername() async {
    String? fetchedUsername = await getUsername(widget.userId);
    setState(() {
      _username = fetchedUsername ?? "";
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
    List<dynamic> fetchedBookmarks =
    await getBookmarksByUser(widget.userId);
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

  void _handleScroll(ScrollMetrics metrics) {
    setState(() {
      _showUsernameInAppBar = metrics.pixels > 0;
    });
  }

  Future<void> _reloadData() async {
    // Fetch the data again and update the state
    await _fetchUsername();
    await _fetchProfileImageUrl();
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
        title: AnimatedOpacity(
          opacity: _showUsernameInAppBar ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Text(
            _username.isNotEmpty ? _username : "username",
            style: GoogleFonts.dmSerifDisplay(
              fontWeight: FontWeight.bold,
            ),
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
                    // TODO
                    break;
                  case "edit":
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                          EditProfileScreen(currentUser: currentUser),
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
        child: NestedScrollView(
          // allows you to build a list of elements that would be scrolled away till the
          // body reached the top
          headerSliverBuilder: (context, _) {
            return [
              SliverToBoxAdapter(
                child: UserWidget(
                  userId: widget.userId,
                  username: _username.isNotEmpty ? _username : "username",
                  profileImageUrl:
                    _profileImageUrl, // Pass the profile image URL
                ),
              ),
            ];
          },
          body: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollUpdateNotification) {
                _handleScroll(notification.metrics); // show username in AppBar
              }
              return false;
            },
            child: Column(
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
                    RefreshIndicator(
                      onRefresh: _reloadData,
                      child: KeepAliveWrapper(
                        key: const ValueKey(0),
                        child: ImageGrid(
                          imagePaths: _bookart
                              .map((map) => map["url"].toString())
                              .toList(),
                          imageTitles: _bookart
                              .map((map) => map["title"].toString())
                              .toList(),
                          bookIds: _bookart
                              .map((map) => map["book_id"].toString())
                              .toList(),
                          userIds: _bookart
                              .map((map) => map["user_id"].toString())
                              .toList(),
                        ),
                      ),
                    ),
                    // ------ Covers content ------
                    RefreshIndicator(
                      onRefresh: _reloadData,
                      child: KeepAliveWrapper(
                        key: const ValueKey(1),
                        child: ImageGrid(
                          imagePaths: _covers
                              .map((map) => map["url"].toString())
                              .toList(),
                          imageTitles: _covers
                              .map((map) => map["title"].toString())
                              .toList(),
                          bookIds: _covers
                              .map((map) => map["book_id"].toString())
                              .toList(),
                          userIds: _covers
                              .map((map) => map["user_id"].toString())
                              .toList(),
                        ),
                      ),
                    ),
                    // ------ Collections content ------
                    RefreshIndicator(
                      onRefresh: _reloadData,
                      child: KeepAliveWrapper(
                        key: const ValueKey(2),
                        child: ImageGrid(
                          imagePaths: _bookmarks
                              .map((map) => map["url"].toString())
                              .toList(),
                          imageTitles: _bookmarks
                              .map((map) => map["title"].toString())
                              .toList(),
                          bookIds: _bookmarks
                              .map((map) => map["book_id"].toString())
                              .toList(),
                          userIds: _bookmarks
                              .map((map) => map["user_id"].toString())
                              .toList(),
                        ),
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
