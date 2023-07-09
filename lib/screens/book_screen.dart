import 'dart:math';
import 'package:bookartify/is_tablet.dart';
import 'package:bookartify/widgets/book_info.dart';
import 'package:bookartify/widgets/book_info_tablet.dart';
import 'package:bookartify/widgets/image_grid.dart';
import 'package:bookartify/widgets/keep_alive_wrapper.dart';
import 'package:bookartify/widgets/synopsis_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/book_search.dart';

class BookScreen extends StatefulWidget {
   final Book book; // Variable to hold the book object

  const BookScreen({Key? key, required this.book}) : super(key: key); // Updated constructor


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
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.book.title, // Updated to use the title passed to BookScreen
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
                child: !isTablet(context) ? BookInfo(book: widget.book) : BookInfoTablet(book: widget.book),
              ),
            ];
          },
          body: Column(
            children: <Widget>[
              TabBar(
                  indicatorColor: const Color(0xFF8A6245),
                  // labelStyle: GoogleFonts.poppins(),
                  tabs: [
                    if (!isTablet(context)) 
                    const Tab(text: 'Synopsis'),
                    const Tab(text: 'Bookart'),
                    const Tab(text: 'Covers'),
                  ]
              ),
              Expanded(
                  child: TabBarView(
                    children: [
                      // ------ Synopsis content ------
                      if (!isTablet(context))
                         KeepAliveWrapper(
                          key: ValueKey(0),
                          child: SynopsisWidget(synopsis:widget.book.description)
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