import 'package:bookartify/models/book_search.dart';
import 'package:bookartify/widgets/info_box.dart';
import 'package:bookartify/widgets/upload_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:bookartify/services/database_api.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookInfo extends StatefulWidget {
  final Book book;

  const BookInfo({Key? key, required this.book}) : super(key: key);

  @override
  _BookInfoState createState() => _BookInfoState();
}

class _BookInfoState extends State<BookInfo> {
  bool isBookSaved = false;

  @override
  void initState() {
    super.initState();
    _checkIfBookSaved();
  }

  void _checkIfBookSaved() async {
    // Get the current user's ID
    String currentUserID = FirebaseAuth.instance.currentUser!.uid;

    // Get the book ID
    String bookID =
        widget.book.id; // Assuming the Book class has a property 'id'

    // Call the function to check if the user is following the book
    try {
      bool isFollowing = await isFollowingBook(currentUserID, bookID);

      setState(() {
        isBookSaved = isFollowing;
      });
    } catch (e) {
      // Handle any errors that occur during the operation
      print("Error checking if book is saved: $e");
    }
  }

  String formatDate(String date) {
    if (date.length == 10) {
      try {
        return DateFormat('dd-MM-yyyy')
            .format(DateFormat('yyyy-MM-dd').parse(date));
      } catch (e) {
        return date;
      }
    } else {
      return date;
    }
  }

  void _toggleSaveBook() async {
    // Get the current user's ID
    String currentUserID = FirebaseAuth.instance.currentUser!.uid;

    // Get the book ID
    String bookID = widget.book.id;

    try {
      if (isBookSaved) {
        // If the book is saved, unfollow it
        await unfollowBook(currentUserID, bookID);
        print("Unfollowed book response: Success");
      } else {
        // If the book is not saved, follow it
        await followBook(currentUserID, bookID);
        print("Followed book response: Success");
      }

      // Toggle the icon state after successful follow/unfollow
      setState(() {
        isBookSaved = !isBookSaved;
      });
    } catch (e) {
      // Handle any errors that occur during the operation
      print("Error saving/unfollowing book: $e");
      // Revert the 'isBookSaved' state to its original value if an error occurs
      setState(() {
        isBookSaved = !isBookSaved;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0, top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5EFE1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: widget.book.thumbnailUrl.isNotEmpty
                      ? FadeInImage.assetNetwork(
                          placeholder: 'images/search_placeholder_image.jpg',
                          image: widget.book.thumbnailUrl,
                          fit: BoxFit.cover,
                          imageErrorBuilder: (BuildContext context,
                              Object exception, StackTrace? stackTrace) {
                            return Image.asset(
                                'images/search_placeholder_image.jpg',
                                fit: BoxFit.cover);
                          },
                        )
                      : Image.asset('images/search_placeholder_image.jpg',
                          fit: BoxFit.cover),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        margin: const EdgeInsetsDirectional.only(start: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.book.title,
                              style: GoogleFonts.dmSerifDisplay(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(" by ${widget.book.author}"),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                        child: GestureDetector(
                          onTap: _toggleSaveBook,
                          child: Icon(
                            isBookSaved ? Icons.check : Icons.add,
                            size: 30,
                            color: isBookSaved
                                ? const Color(0xFFBFA054)
                                : const Color(0xFF2F2F2F),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InfoBox(
                      title: "Released",
                      info: formatDate(widget.book.publishedDate),
                    ),
                    const SizedBox(width: 10.0),
                    InfoBox(
                      title: "Pages",
                      info: widget.book.pageCount.toString(),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                IntrinsicWidth(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      UploadButton(
                        buttonLabel: 'Upload your cover',
                        onPressed: () {
                          // TODO
                        },
                        backgroundColor: const Color(0xFFBFA054),
                        foregroundColor: const Color(0xFF2F2F2F),
                        icon: const Icon(
                          CupertinoIcons.add,
                          size: 22,
                        ),
                      ),
                      UploadButton(
                        buttonLabel: 'Upload your art',
                        onPressed: () {
                          // TODO
                        },
                        backgroundColor: const Color(0xFF2F2F2F),
                        foregroundColor: const Color(0xFFFBF8F2),
                        icon: const Icon(
                          CupertinoIcons.add,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}





