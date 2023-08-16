import 'package:bookartify/screens/bookcover_edit.dart';
import 'package:bookartify/services/database_api.dart';
import 'package:bookartify/widgets/icons_and_buttons/like_icon.dart';
import 'package:bookartify/widgets/icons_and_buttons/save_icon.dart';
import 'package:bookartify/widgets/icons_and_buttons/share_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:bookartify/models/book_model.dart';
import 'package:bookartify/screens/book_screen.dart';
import 'package:bookartify/screens/profile_screen.dart';
import 'package:bookartify/screens/ARart_screen.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';

class ArtSoloScreen extends StatefulWidget {
  final String type;
  final dynamic post;
  final Book book;

  const ArtSoloScreen(
      {super.key, required this.type, required this.post, required this.book});

  @override
  State<ArtSoloScreen> createState() => _ArtSoloScreenState();
}

class _ArtSoloScreenState extends State<ArtSoloScreen> {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  bool isSaved = false;
  UnityWidgetController? _unityWidgetController;

  @override
  void initState() {
    super.initState();
    getSavedStatus();
  }

  Future<void> getSavedStatus() async {
    bool saved = (widget.type == "art")
        ? await isBookmarkedArt(userId, widget.post["id"].toString())
        : await isBookmarkedCover(userId, widget.post["id"].toString());
    if (mounted) {
      setState(() {
        isSaved = saved;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<String> saveOrUnsaveText(String type, String id) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    if ((type == "art" && await isBookmarkedArt(uid, id)) ||
        (type == "cover" && await isBookmarkedCover(uid, id))) {
      return "Unsave";
    } else {
      return "Save";
    }
  }

  @override
  Widget build(BuildContext context) {
    void navigateToUserProfile() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ProfileScreen(userId: widget.post["user_id"].toString()),
        ),
      );
    }

    Future<String> getButtonText() async {
      if (userId == widget.post["user_id"].toString()) {
        return "Delete";
      } else {
        return await saveOrUnsaveText(
            widget.type, widget.post["id"].toString());
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        centerTitle: true,
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.black),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
        title: Text(
          widget.post["title"].toString(),
          style: GoogleFonts.dmSerifDisplay(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    widget.post["url"].toString(),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 2.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(42),
                    color: const Color.fromARGB(70, 192, 162, 73),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.post["title"].toString(),
                                style: GoogleFonts.dmSerifDisplay(
                                    fontSize: 19, fontWeight: FontWeight.w600),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'By ',
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    TextSpan(
                                      text: widget.post["username"].toString(),
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300,
                                        decoration: TextDecoration.underline,
                                      ),
                                      // Add the onTap callback here
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = navigateToUserProfile,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              LikeIcon(
                                type: widget.type,
                                id: widget.post["id"].toString(),
                              ),
                              const SizedBox(width: 10),
                              SaveIcon(
                                type: widget.type,
                                id: widget.post["id"].toString(),
                              ),
                              ShareButton(
                                post: widget.post,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BookScreen(book: widget.book),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Book Title:",
                              style: GoogleFonts.dmSerifDisplay(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              widget.book.title,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BookScreen(book: widget.book),
                            ),
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Author:",
                              style: GoogleFonts.dmSerifDisplay(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              widget.book.author,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 10, 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Description",
                      style: GoogleFonts.dmSerifDisplay(
                        fontSize: 19,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2.5),
                    Text(
                      widget.post["description"] ?? "No description added.",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Visibility(
                      visible: userId == widget.post["user_id"].toString(),
                      child: Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            widget.type == "art"
                                ? await deleteArt(
                                userId, widget.post["id"].toString())
                                : await deleteCover(
                                userId, widget.post["id"].toString());
                            Navigator.pop(context);
                            // TODO: reload page after deleting
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            const Color.fromARGB(255, 192, 162, 73),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.5),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 0,
                            ),
                            child: Text(
                              "Delete",
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: userId == widget.post["user_id"].toString(),
                      child: const SizedBox(
                        width: 10,
                      ),
                    ),
                    // Expanded(
                    //   child: ElevatedButton(
                    //     onPressed: () async {
                    //       if (userId == widget.post["user_id"].toString()) {
                    //         widget.type == "art"
                    //             ? deleteArt(
                    //                 userId, widget.post["id"].toString())
                    //             : deleteCover(
                    //                 userId, widget.post["id"].toString());
                    //         Navigator.pop(context);
                    //         // TODO: reload page after deleting
                    //       } else {
                    //         if (widget.type == "art" && !isSaved) {
                    //           await bookmarkArt(
                    //               userId, widget.post["id"].toString());
                    //         } else if (widget.type == "art" && isSaved) {
                    //           await unbookmarkArt(
                    //               userId, widget.post["id"].toString());
                    //         } else if (widget.type == "cover" && !isSaved) {
                    //           await bookmarkCover(
                    //               userId, widget.post["id"].toString());
                    //         } else {
                    //           await unbookmarkCover(
                    //               userId, widget.post["id"].toString());
                    //         }
                    //
                    //         setState(() {
                    //           isSaved = !isSaved;
                    //         });
                    //       }
                    //     },
                    //     style: ElevatedButton.styleFrom(
                    //       backgroundColor:
                    //           const Color.fromARGB(255, 192, 162, 73),
                    //       foregroundColor: Colors.black,
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(12.5),
                    //       ),
                    //     ),
                    //     child: Padding(
                    //       padding: const EdgeInsets.symmetric(
                    //         vertical: 10,
                    //         horizontal: 0,
                    //       ),
                    //       child: FutureBuilder<String>(
                    //         future: getButtonText(),
                    //         builder: (context, snapshot) {
                    //           if (snapshot.connectionState ==
                    //               ConnectionState.waiting) {
                    //             return const Center(
                    //               child: CircularProgressIndicator(),
                    //             );
                    //           } else if (snapshot.hasError) {
                    //             return Text("Error ${snapshot.error}");
                    //           } else {
                    //             return Text(
                    //               snapshot.data!,
                    //               style: GoogleFonts.poppins(
                    //                   fontSize: 16,
                    //                   fontWeight: FontWeight.w400),
                    //             );
                    //           }
                    //         },
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(
                    //   width: 10,
                    // ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          print("Widget type: ${widget.type}");
                          if (widget.type == "cover") {
                            String imageUrl = widget.post["url"].toString();
                            String base64Image =
                                await getImageAsBase64String(imageUrl);
                            _unityWidgetController?.postMessage(
                                'Canvas', 'SetMaterial2', base64Image);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => BookCover()),
                            );
                          } else if (widget.type == "art") {
                            String imageUrl = widget.post["url"].toString();
                            String base64Image =
                                await getImageAsBase64String(imageUrl);
                            _unityWidgetController?.postMessage(
                                'FramedPhoto', 'SetMaterial', base64Image);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ARArt()),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 47, 47, 47),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.5),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 0,
                          ),
                          child: Text(
                            "View in AR",
                            style: GoogleFonts.poppins(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Positioned(
                bottom: 0,
                left: (MediaQuery.of(context).size.width - 200) /
                    2, // Center horizontally
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
    );
  }
}
