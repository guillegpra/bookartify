import 'package:bookartify/widgets/image_grid.dart';
import 'package:bookartify/widgets/user_counter.dart';
import 'package:bookartify/widgets/user_info.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "username",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              letterSpacing: -0.7
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                // Handle more options button
              },
              icon: Icon(Icons.more_vert)
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          // backgroundImage: AssetImage("..."),
                        ),
                        SizedBox(width: 10),
                        Row(
                          children: [
                            UserCounter(
                                name: "Art",
                                number: 26 // TODO: change number
                            ),
                            SizedBox(width: 10),
                            UserCounter(
                                name: "Followers",
                                number: 89 // TODO: change number
                            )
                          ],
                        )
                      ],
                    ),
                    UserInfo()
                  ],
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
                      placeholderContent,
                      // ------ Covers content ------
                      placeholderContent,
                      // ------ Collections content ------
                      placeholderContent,
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
