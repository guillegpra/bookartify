import 'package:bookartify/models/book_model.dart';
import 'package:bookartify/screens/book_screen.dart';
import 'package:bookartify/screens/bookcover_edit.dart';
import 'package:bookartify/screens/profile_screen.dart';
import 'package:bookartify/services/google_books_api.dart';
import 'package:bookartify/services/database_api.dart';
import 'package:bookartify/widgets/icons_and_buttons/save_icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bookartify/widgets/icons_and_buttons/share_button.dart';
import 'package:bookartify/widgets/icons_and_buttons/like_icon.dart';
import 'package:bookartify/widgets/search/inactive_searchbar.dart';
import 'package:bookartify/screens/art_solo.dart';
import 'package:bookartify/screens/ARart_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? currentUser;
  final _googleBooksAPI = GoogleBooksApi();
  late Future<List<dynamic>> forYouPosts;
  UnityWidgetController? _unityWidgetController;

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

  // Initialize Unity
  void _onUnityCreated(UnityWidgetController controller) {
    _unityWidgetController = controller;
  }

  // Handle messages from Unity
  void _onUnityMessage(message) {
    print('Received message from Unity: $message');
  }

  Future<String> getImageAsBase64String(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      final bytes = response.bodyBytes;
      return base64Encode(bytes);
    } else {
      throw Exception('Failed to load image');
    }
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
                      return FutureBuilder(
                        future: _fetchBooksForYou(posts),
                        builder: (context, snapshot) {
                          List<Book> books = snapshot.data ?? [];
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
                                      color: const Color.fromRGBO(
                                          245, 239, 225, 1),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      ArtSoloScreen(
                                                    type: posts[index]["type"]
                                                        .toString(),
                                                    post: posts[
                                                        index], // Pass the appropriate post data
                                                    book: books[
                                                        index], // Pass the appropriate book data (if available)
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Stack(
                                                    children: [
                                                      Image.network(
                                                        posts[index]["url"]
                                                            .toString(),
                                                        loadingBuilder:
                                                            (BuildContext
                                                                    context,
                                                                Widget child,
                                                                ImageChunkEvent?
                                                                    loadingProgress) {
                                                          if (loadingProgress ==
                                                              null) {
                                                            return child;
                                                          }
                                                          return Center(
                                                            child:
                                                                CircularProgressIndicator(
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
                                                      Positioned(
                                                        top: 10,
                                                        right: 10,
                                                        child: Container(
                                                          width: 35,
                                                          height: 35,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.4), // White background color
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          child:
                                                              GestureDetector(
                                                            onTap: () async {
                                                              if (posts[index][
                                                                      "type"] ==
                                                                  "cover") {
                                                                String
                                                                    imageUrl =
                                                                    posts[index]
                                                                            [
                                                                            'url']
                                                                        .toString();
                                                                String
                                                                    base64Image =
                                                                    await getImageAsBase64String(
                                                                        imageUrl);
                                                                _unityWidgetController
                                                                    ?.postMessage(
                                                                        'Canvas',
                                                                        'SetMaterial2',
                                                                        base64Image);
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              BookCover()),
                                                                );
                                                              } else if ((posts[
                                                                          index]
                                                                      [
                                                                      "type"] ==
                                                                  "art")) {
                                                                String
                                                                    imageUrl =
                                                                    posts[index]
                                                                            [
                                                                            "url"]
                                                                        .toString();
                                                                String
                                                                    base64Image =
                                                                    await getImageAsBase64String(
                                                                        imageUrl);
                                                                _unityWidgetController?.postMessage(
                                                                    'FramedPhoto',
                                                                    'SetMaterial',
                                                                    base64Image);
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              ARArt()),
                                                                );
                                                              }
                                                            },
                                                            child: Image.asset(
                                                              'images/augmented-reality.png',
                                                              width: 10,
                                                              height: 10,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        bottom: 0,
                                                        left: (MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                200) /
                                                            2, // Center horizontally
                                                        child: SizedBox(
                                                          width: 1,
                                                          height: 1,
                                                          child: UnityWidget(
                                                            onUnityCreated:
                                                                _onUnityCreated,
                                                            onUnityMessage:
                                                                _onUnityMessage,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8.0,
                                                horizontal: 10.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Expanded(
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ArtSoloScreen(
                                                            type: posts[index]
                                                                    ["type"]
                                                                .toString(),
                                                            post: posts[index],
                                                            book: books[index],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Text(
                                                      posts[index]["title"]
                                                          .toString(),
                                                      style: GoogleFonts
                                                          .dmSerifDisplay(
                                                              fontSize: 18),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 8.0),
                                                LikeIcon(
                                                  type: posts[index]["type"]
                                                      .toString(),
                                                  id: posts[index]["id"]
                                                      .toString(),
                                                ),
                                                const SizedBox(width: 8.0),
                                                SaveIcon(
                                                  type: posts[index]["type"]
                                                      .toString(),
                                                  id: posts[index]["id"]
                                                      .toString(),
                                                ),
                                                const SizedBox(width: 8.0),
                                                ShareButton(
                                                  post: posts[index],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10.0, 1.0, 10.0, 1.0),
                                            child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: posts[index]["type"]
                                                        .toString() == "art" ? 'Artwork by '
                                                    : 'Cover by ',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 15,
                                                      color: Colors.grey,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: posts[index]
                                                            ["username"]
                                                        .toString(),
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
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10.0, 1.0, 10.0, 10.0),
                                            child: RichText(
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
                                                    text: books[index].title,
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
                                                                  book: books[
                                                                      index],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                  ),
                                                ],
                                              ),
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
