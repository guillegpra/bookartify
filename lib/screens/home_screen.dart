import 'package:bookartify/models/book_search.dart';
import 'package:bookartify/screens/book_screen.dart';
import 'package:bookartify/screens/profile_screen.dart';
import 'package:bookartify/services/google_books_api.dart';
import 'package:bookartify/services/database_api.dart';
import 'package:bookartify/services/usernames_db.dart';
import 'package:bookartify/widgets/icons_and_buttons/save_icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bookartify/widgets/icons_and_buttons/share_button.dart';
import 'package:bookartify/widgets/icons_and_buttons/like_icon.dart';
import 'package:bookartify/widgets/search/inactive_searchbar.dart';
import 'package:bookartify/screens/art_solo.dart';
import 'package:http/http.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? currentUser;
  final _googleBooksAPI = GoogleBooksApi();
  late Future<List<dynamic>> forYouPosts;
  //late List<Book> books = [];

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    forYouPosts = _fetchForYou();
  }

  Future<List<dynamic>> _fetchForYou() async {
    if (currentUser != null) {
      return await getForYouByUser(currentUser!.uid);
    } else {
      return [];
    }
  }

  Future<List<Book>> _fetchBooksForYou(List<dynamic> forYouData) async {
    List<Book> books = [];

    for (var item in forYouData) {
      String bookId = item["book_id"].toString();
      Book? book = await _googleBooksAPI.getBookFromId(bookId);
      if (book != null) {
        books.add(book);
      }
    }

    return books;
  }

  Future<List<String>> _fetchUsernamesForYou(List<dynamic> forYouData) async {
    List<String> usernames = [];

    for (var item in forYouData) {
      String userId = item["user_id"].toString();
      String? username = await getUsername(userId);
      if (username != null) {
        usernames.add(username);
      }
    }

    return usernames;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InactiveSearchBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: RefreshIndicator(
                onRefresh: () {
                  setState(() {});
                  return _fetchForYou();
                },
                child: FutureBuilder<List<dynamic>>(
                  future: _fetchForYou(),
                  // future: forYouPosts,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else {
                      List<dynamic> posts = snapshot.data ?? [];
                      return RefreshIndicator(
                        onRefresh: _fetchForYou,
                        child: ListView.builder(
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            if (posts.isEmpty) {
                              return const Text(
                                  "No posts yet. Follow books and users on the Explore page.");
                            } else {
                              return Card(
                                color: const Color.fromRGBO(245, 239, 225, 1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          posts[index]["url"].toString(),
                                          loadingBuilder: (BuildContext context,
                                              Widget child,
                                              ImageChunkEvent?
                                                  loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 10.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              posts[index]["title"].toString(),
                                              style: GoogleFonts.dmSerifDisplay(
                                                  fontSize: 18),
                                            ),
                                          ),
                                          const SizedBox(width: 8.0),
                                          LikeIcon(
                                            type:
                                                posts[index]["type"].toString(),
                                            id: posts[index]["id"].toString(),
                                          ),
                                          const SizedBox(width: 8.0),
                                          const SaveIcon(),
                                          const SizedBox(width: 8.0),
                                          ShareButton(
                                            onPressed: () {
                                              // TODO: share functionality
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10.0, 1.0, 10.0, 1.0),
                                      child: FutureBuilder<List<String>>(
                                        future: _fetchUsernamesForYou(posts),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                "Error: ${snapshot.error}");
                                          } else {
                                            List<String> usernames =
                                                snapshot.data ?? [];
                                            String username =
                                                usernames.isNotEmpty
                                                    ? usernames[index]
                                                    : "";
                                            return RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: 'By ',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 15,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: username,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      decoration: TextDecoration
                                                          .underline,
                                                    ),
                                                    // Add the onTap callback here
                                                    recognizer:
                                                        TapGestureRecognizer()
                                                          ..onTap = () async {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ProfileScreen(
                                                                  userId: posts[
                                                                              index]
                                                                          [
                                                                          "user_id"]
                                                                      .toString(),
                                                                ),
                                                              ),
                                                            );
                                                            // TODO
                                                          },
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10.0, 1.0, 10.0, 10.0),
                                      child: FutureBuilder<List<Book>>(
                                        future: _fetchBooksForYou(posts),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator();
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                "Error: ${snapshot.error}");
                                          } else {
                                            List<Book> books =
                                                snapshot.data ?? [];
                                            Book book = books.isNotEmpty
                                                ? books[index]
                                                : Book(
                                                    id: "",
                                                    title: "No Title",
                                                    author: "No Author",
                                                    thumbnailUrl: "",
                                                    publishedDate: "",
                                                    pageCount: 0,
                                                    description: "",
                                                  );
                                            return RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: 'For ',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 15,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: book.title,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      decoration: TextDecoration
                                                          .underline,
                                                    ),
                                                    // Add the onTap callback here
                                                    recognizer:
                                                        TapGestureRecognizer()
                                                          ..onTap = () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        BookScreen(
                                                                  book: book,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
