import 'package:bookartify/models/book_model.dart';
import 'package:bookartify/screens/book_screen.dart';
import 'package:bookartify/screens/profile_screen.dart';
import 'package:bookartify/services/google_books_api.dart';
import 'package:bookartify/services/database_api.dart' as database_api;
import 'package:bookartify/widgets/icons_and_buttons/save_icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:bookartify/widgets/icons_and_buttons/share_button.dart';
import 'package:bookartify/widgets/icons_and_buttons/like_icon.dart';
import 'package:bookartify/widgets/search/inactive_searchbar.dart';
import 'package:bookartify/screens/art_solo.dart';
import 'package:bookartify/services/usernames_db.dart';
import 'package:bookartify/screens/ARart_screen.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

class ViewMoreScreen extends StatefulWidget {
  const ViewMoreScreen({Key? key, required this.genre, required this.posts})
      : super(key: key);

  final String genre;
  final List<Map<String, dynamic>> posts;

  @override
  _ViewMoreScreenState createState() => _ViewMoreScreenState();
}

class _ViewMoreScreenState extends State<ViewMoreScreen> {
  // This map will hold the user ids and their names.
  Map<String, String> userNames = {};
  UnityWidgetController? _unityWidgetController;

  @override
  @override
  void initState() {
    super.initState();
    _fetchUserNames();
  }

  // Populate the userNames map using the getUserById function.
  _fetchUserNames() async {
    for (var post in widget.posts) {
      String userId = post['user_id'];

      if (!userNames.containsKey(userId)) {
        // Fetch and add the username if it's not already in the map.
        String userName = await database_api.getUsernameById(userId);
        setState(() {
          userNames[userId] = userName;
        });
      }
    }
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

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.genre,
          style: GoogleFonts.dmSerifDisplay(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: ListView.builder(
                itemCount: widget.posts.length,
                itemBuilder: (context, index) {
                  var post = widget.posts[index];

                  // Modify the post to include the username
                  post['username'] = userNames[post['user_id']];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: _buildCard(context, post),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, Map<String, dynamic> post) {
    Book book = post['book_details'];
    return Card(
      color: const Color.fromRGBO(245, 239, 225, 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArtSoloScreen(
                    type: post["type"].toString(),
                    post: post, // Pass the post data
                    book: book, // Pass the book data
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    Image.network(
                      post['url'].toString(),
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
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
                        decoration: BoxDecoration(
                          color: Colors.white
                              .withOpacity(0.4), // White background color
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            String imageUrl = post['url'].toString();
                            String base64Image = await getImageAsBase64String(imageUrl);
                            _unityWidgetController?.postMessage(
                              'FramedPhoto', 
                              'SetMaterial',
                              base64Image
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ARArt()),
                            );
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
                      left: (MediaQuery.of(context).size.width - 200) / 2, // Center horizontally
                      child: Container(
                        width: 1,
                        height: 1,
                        child: UnityWidget(
                          onUnityCreated: _onUnityCreated,
                          onUnityMessage: _onUnityMessage,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArtSoloScreen(
                            type: post["type"].toString(),
                            post: post, // Pass the post data
                            book: book, // Pass the book data
                          ),
                        ),
                      );
                    },
                    child: Text(
                      post["title"].toString(),
                      style: GoogleFonts.dmSerifDisplay(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                LikeIcon(
                  type: post['type'].toString(),
                  id: post["id"].toString(),
                ),
                const SizedBox(width: 8.0),
                SaveIcon(
                  type: post['type'].toString(),
                  id: post["id"].toString(),
                ),
                const SizedBox(width: 8.0),
                ShareButton(
                  post: {
                    "title": post["title"]
                        .toString(), // Replace with the actual art title
                    "url": post['url'].toString(),
                  }, // Replace with the actual image URL
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 1.0, 10.0, 1.0),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'By ',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: '${userNames[post['user_id']]}',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                    // Add the onTap callback here
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                              userId: post["user_id"].toString(),
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
            padding: const EdgeInsets.fromLTRB(10.0, 1.0, 10.0, 10.0),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'For ',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: book.title,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                    ),
                    // Add the onTap callback here
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookScreen(
                              book: book,
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
}
