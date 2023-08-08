import 'package:bookartify/widgets/icons_and_buttons/like_icon.dart';
import 'package:bookartify/widgets/icons_and_buttons/save_icon.dart';
import 'package:bookartify/widgets/icons_and_buttons/share_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bookartify/models/book_model.dart';
import 'package:bookartify/screens/book_screen.dart';
import 'package:bookartify/screens/profile_screen.dart';

class ArtSoloScreen extends StatelessWidget {
  final String type;
  final dynamic post;
  final Book book;

  const ArtSoloScreen({
    Key? key,
    required this.type,
    required this.post,
    required this.book,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void navigateToUserProfile() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ProfileScreen(userId: post["user_id"].toString()),
        ),
      );
    }

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
          post["title"].toString(),
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
                    post["url"].toString(),
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
                                post["title"].toString(),
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
                                      text: post["username"].toString(),
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
                                type: type,
                                id: post["id"].toString(),
                              ),
                              const SizedBox(width: 10),
                              SaveIcon(
                                type: type,
                                id: post["id"].toString(),
                              ),
                              ShareButton(
                                post: post,
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
                              builder: (context) => BookScreen(book: book),
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
                              book.title,
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
                              builder: (context) => BookScreen(book: book),
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
                              book.author,
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
                      post["description"] ?? "No description added.",
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
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (FirebaseAuth.instance.currentUser!.uid ==
                              post["user_id"].toString()) {
                            // TODO: delete post
                          } else {
                            // TODO: save/unsave
                          }
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
                            FirebaseAuth.instance.currentUser!.uid ==
                                    post["user_id"].toString()
                                ? "Delete"
                                : "Add to Collection",
                            style: GoogleFonts.poppins(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: connect to AR
                          print("Button pressed!");
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
                            horizontal: 28,
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
            ],
          ),
        ),
      ),
    );
  }
}
