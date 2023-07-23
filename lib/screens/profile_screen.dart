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
  const ProfileScreen({super.key});

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
  bool _showUsernameInAppBar = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    currentUser = FirebaseAuth.instance.currentUser;
    _fetchUsername();
    _fetchProfileImageUrl(); // Fetch profile image URL
  }

  Future<void> _fetchProfileImageUrl() async {
    if (currentUser != null) {
      String? fetchedImageUrl = await getUserProfilePic(
          currentUser!.uid); // Use your function to get the profile pic
      setState(() {
        _profileImageUrl = fetchedImageUrl ?? "";
      });
    }
  }

  Future<void> _fetchUsername() async {
    if (currentUser != null) {
      String? fetchedUsername = await getUsername(currentUser!.uid);
      setState(() {
        _username = fetchedUsername ?? "";
      });
    }
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

  @override
  Widget build(BuildContext context) {
    const placeholderContent = ImageGrid(
      imagePaths: [
        "images/fanart.jpg",
        "images/fanart.jpg",
        "images/fanart.jpg",
        "images/fanart.jpg",
        "images/fanart.jpg",
        "images/fanart.jpg",
        "images/fanart.jpg",
        "images/fanart.jpg",
      ],
      imageTitles: [
        "Evelyn Hugo",
        "Evelyn Hugo",
        "Evelyn Hugo",
        "Evelyn Hugo",
        "Evelyn Hugo",
        "Evelyn Hugo",
        "Evelyn Hugo",
        "Evelyn Hugo",
      ],
    );

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
          PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
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
            child: const Column(
              children: <Widget>[
                TabBar(
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
                        key: ValueKey(0), child: placeholderContent),
                    // ------ Covers content ------
                    KeepAliveWrapper(
                        key: ValueKey(1), child: placeholderContent),
                    // ------ Collections content ------
                    KeepAliveWrapper(
                        key: ValueKey(2), child: placeholderContent),
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
