import 'package:bookartify/widgets/image_grid.dart';
import 'package:bookartify/widgets/keep_alive_wrapper.dart';
import 'package:bookartify/widgets/user_info.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin,
    AutomaticKeepAliveClientMixin<ProfileScreen> {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

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
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "username",
          style: GoogleFonts.dmSerifDisplay(
              fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                // Handle more options button
              },
              icon: const Icon(Icons.more_vert)
          )
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          // allows you to build a list of elements that would be scrolled away till the
          // body reached the top
          headerSliverBuilder: (context, _) {
            return const [
              SliverToBoxAdapter(
                child: UserInfo(
                  username: "username",
                ),
              ),
            ];
          },
          body: const Column(
            children: <Widget>[
              TabBar(
                  indicatorColor: Color(0xFF8A6245),
                  // labelStyle: GoogleFonts.poppins(),
                  tabs: [
                    Tab(text: 'Bookart'),
                    Tab(text: 'Covers'),
                    Tab(text: 'Collections'),
                  ]
              ),
              Expanded(
                  child: TabBarView(
                    children: [
                      // ------ Bookart content ------
                      KeepAliveWrapper(
                          key: ValueKey(0),
                          child: placeholderContent
                      ),
                      // ------ Covers content ------
                      KeepAliveWrapper(
                          key: ValueKey(1),
                          child: placeholderContent
                      ),
                      // ------ Collections content ------
                      KeepAliveWrapper(
                          key: ValueKey(2),
                          child: placeholderContent
                      ),
                    ],
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
