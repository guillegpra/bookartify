import 'package:bookartify/widgets/image_grid.dart';
import 'package:bookartify/widgets/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileTabs extends StatefulWidget {
  @override
  _ProfileTabsState createState() => _ProfileTabsState();
}

class _ProfileTabsState extends State<ProfileTabs> with SingleTickerProviderStateMixin {
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
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
            controller: _tabController,
            children: [
              // Bookart content
              const ImageGrid(
                imagePaths: const [
                  "images/fanart.jpg",
                  "images/fanart.jpg",
                  "images/fanart.jpg",
                  "images/fanart.jpg",
                  "images/fanart.jpg",
                  "images/fanart.jpg",
                  "images/fanart.jpg",
                  "images/fanart.jpg",
                ],
                imageTitles: const [
                  "Evelyn Hugo",
                  "Evelyn Hugo",
                  "Evelyn Hugo",
                  "Evelyn Hugo",
                  "Evelyn Hugo",
                  "Evelyn Hugo",
                  "Evelyn Hugo",
                  "Evelyn Hugo",
                ],
              ),
              // Covers content
              Center(child: Text("Covers")),
              // Collection content
              Center(child: Text("Collection")),
            ],
          )
        )
      ],
    );
  }
}
