import 'dart:math';

import 'package:bookartify/is_tablet.dart';
import 'package:bookartify/widgets/book_info.dart';
import 'package:bookartify/widgets/book_info_tablet.dart';
import 'package:bookartify/widgets/image_grid.dart';
import 'package:bookartify/widgets/keep_alive_wrapper.dart';
import 'package:bookartify/widgets/synopsis_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({super.key});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
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
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black
          ),
          onPressed: () {
            print('To be worked!!');
          },
        ),
        title: Text(
          "Book Title",
          style: GoogleFonts.dmSerifDisplay(
              fontWeight: FontWeight.w500,
              letterSpacing: -0.7
          ),
        ),
        centerTitle: true,
      ),
      body: DefaultTabController(
        length: isTablet(context) ? 2 : 3,
        child: NestedScrollView(
          // allows you to build a list of elements that would be scrolled away till the
          // body reached the top
          headerSliverBuilder: (context, _) {
            return [
              SliverToBoxAdapter(
                child: !isTablet(context) ? const BookInfo() : const BookInfoTablet(),
              ),
            ];
          },
          body: Column(
            children: <Widget>[
              TabBar(
                  indicatorColor: Color(0xFF8A6245),
                  // labelStyle: GoogleFonts.poppins(),
                  tabs: [
                    if (!isTablet(context)) Tab(text: 'Synopsis'),
                    Tab(text: 'Bookart'),
                    Tab(text: 'Covers'),
                  ]
              ),
              Expanded(
                  child: TabBarView(
                    children: [
                      // ------ Synopsis content ------
                      if (!isTablet(context))
                        const KeepAliveWrapper(
                          key: ValueKey(0),
                          child: SynopsisWidget(synopsis: "The Seven Husbands of Evelyn Hugo tells the story of old Hollywood actor Evelyn Hugo, determined to secure an A-List spot in the industry by doing whatever it takes to get there. While attempting to complete her rise to stardom, she marries  seven husbands and outlives them all. Later in her life, Hugo then hires a lesser-known journalist to write her memoir and, for the first time in her decorated life, tells details and secrets about her love life leaving readers with no choice but to keep turning the pages.\n\nMonique Grant – the journalist hired by Hugo – goes on her own journey while learning about the actress and as the book goes on, Grant seeks to discover why she was chosen to document Hugo’s life. The reason is later revealed, in a twist leaving readers on edge.")
                        ),
                      // ------ Covers content ------
                      KeepAliveWrapper(
                        key: ValueKey(isTablet(context) ? 0 : 1),
                        child: placeholderContent
                      ),
                      // ------ Collections content ------
                      KeepAliveWrapper(
                        key: ValueKey(isTablet(context) ? 1 : 2),
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

