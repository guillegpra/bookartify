import 'package:bookartify/models/book_search.dart';
import 'package:bookartify/widgets/book_info.dart';
import 'package:bookartify/widgets/book_info_tablet.dart';
import 'package:bookartify/widgets/image_grid.dart';
import 'package:bookartify/widgets/icons_and_buttons/save_icon.dart';
import 'package:bookartify/widgets/keep_alive_wrapper.dart';
import 'package:bookartify/widgets/synopsis_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookScreen extends StatefulWidget {
  final Book book;

  const BookScreen({Key? key, required this.book}) : super(key: key);

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  bool _showTitleInAppBar = false;

  void _handleScroll(ScrollMetrics metrics) {
    setState(() {
      _showTitleInAppBar = metrics.pixels > 0;
    });
  }

  Future<List<dynamic>> getArtByBook(String bookId) async {
    final http.Response response = await http
        .get(Uri.parse("https://bookartify.scss.tcd.ie/book/$bookId/art"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data as List<dynamic>;
    } else {
      throw Exception("Failed to load art for book with id: $bookId");
    }
  }

  Future<List<dynamic>> getCoversByBook(String bookId) async {
    final http.Response response = await http
        .get(Uri.parse("https://bookartify.scss.tcd.ie/book/$bookId/covers"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data as List<dynamic>;
    } else {
      throw Exception("Failed to load covers for book with id: $bookId");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: AnimatedOpacity(
          opacity: _showTitleInAppBar ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: Text(
            widget.book.title,
            style: GoogleFonts.dmSerifDisplay(
                fontWeight: FontWeight.w500, letterSpacing: -0.7),
          ),
        ),
        centerTitle: true,
      ),
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (context, _) {
            return [
              SliverToBoxAdapter(
                child: BookInfo(book: widget.book),
              ),
            ];
          },
          body: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollUpdateNotification) {
                _handleScroll(notification.metrics);
              }
              return false;
            },
            child: Column(
              children: <Widget>[
                const TabBar(
                  indicatorColor: Color(0xFF8A6245),
                  tabs: [
                    Tab(text: 'Synopsis'),
                    Tab(text: 'Bookart'),
                    Tab(text: 'Covers'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      // ------ Synopsis content ------
                      KeepAliveWrapper(
                        key: const ValueKey(0),
                        child:
                            Center(child: SynopsisWidget(synopsis: widget.book.description)),
                      ),
                      // ------ Covers content ------
                      KeepAliveWrapper(
                        key: const ValueKey(1),
                        child: FutureBuilder<List<dynamic>>(
                          future: getArtByBook(widget.book.id),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text("Error: ${snapshot.error}"),
                              );
                            } else {
                              final List<dynamic> artworkData =
                                  snapshot.data ?? [];
                              if (artworkData.isEmpty) {
                                return const Center(
                                  child: Text("No art for this book yet"),
                                );
                              } else {
                                return ImageGrid(
                                  types: List.filled(artworkData.length, "art"),
                                  posts: artworkData,
                                );
                              }
                            }
                          },
                        ),
                      ),
                      // ------ Collections content ------
                      KeepAliveWrapper(
                        key: const ValueKey(2),
                        child: FutureBuilder<List<dynamic>>(
                          future: getCoversByBook(widget.book.id),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text("Error: ${snapshot.error}"),
                              );
                            } else {
                              final List<dynamic> coversData =
                                  snapshot.data ?? [];
                              if (coversData.isEmpty) {
                                return const Center(
                                  child: Text("No covers for this book yet"),
                                );
                              } else {
                                return ImageGrid(
                                  types:
                                      List.filled(coversData.length, "cover"),
                                  posts: coversData,
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
