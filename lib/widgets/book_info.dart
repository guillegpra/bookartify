import 'package:bookartify/models/book_model.dart';
import 'package:bookartify/screens/cover_upload.dart';
import 'package:bookartify/screens/fanart_upload.dart';
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
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth > 1279.0) {
          // Tablet Landscape Mode
          return _buildTabletLandscapeLayout();
        } else if (constraints.maxWidth > 600) {
          // Pixel 6 Sized Screen
          return _buildPortraitLayout();
        } else {
          // Phone/Tablet Portrait Mode
          return _buildPhoneLayout();
        }
      },
    );
  }

  Widget _buildPhoneLayout() {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
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
          const SizedBox(width: 8.0),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Centered title and follow icon
                Center(
                  child: Column(
                    children: [
                      SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              widget.book.title,
                              style: GoogleFonts.dmSerifDisplay(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 5.0), // Add spacing
                          GestureDetector(
                            onTap: _toggleSaveBook,
                            child: Icon(
                              isBookSaved ? Icons.check : Icons.add,
                              size: 30,
                              color: isBookSaved
                                  ? const Color(0xFFBFA054)
                                  : const Color(0xFF2F2F2F),
                            ),
                          ),
                        ],
                      ),
                      Text(" by ${widget.book.author}"),
                    ],
                  ),
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
                Column(
                  // Stack the buttons vertically
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Center the buttons
                  children: [
                    Container(
                      width: 208, // Set a specific width for the button
                      child: UploadButton(
                        buttonLabel: 'Upload your cover',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CoverUploadPage()),
                          );
                        },
                        backgroundColor: const Color(0xFFBFA054),
                        foregroundColor: const Color(0xFF2F2F2F),
                        icon: const Icon(
                          CupertinoIcons.add,
                          size: 22,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0), // Add spacing between buttons
                    Container(
                      width: 208, // Set a specific width for the button
                      child: UploadButton(
                        buttonLabel: 'Upload your art',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ArtUploadPage()),
                          );
                        },
                        backgroundColor: const Color(0xFF2F2F2F),
                        foregroundColor: const Color(0xFFFBF8F2),
                        icon: const Icon(
                          CupertinoIcons.add,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLandscapeLayout() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0, top: 8.0, left: 200),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Smaller thumbnail size in landscape mode
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Container(
                width: 150,
                height: 420,
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
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Image.asset(
                          'images/search_placeholder_image.jpg',
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
          ),

          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Centered title and follow icon
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.book.title,
                            style: GoogleFonts.dmSerifDisplay(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(width: 8.0), // Add spacing
                          GestureDetector(
                            onTap: _toggleSaveBook,
                            child: Icon(
                              isBookSaved ? Icons.check : Icons.add,
                              size: 30,
                              color: isBookSaved
                                  ? const Color(0xFFBFA054)
                                  : const Color(0xFF2F2F2F),
                            ),
                          ),
                        ],
                      ),
                      Text(" by ${widget.book.author}"),
                    ],
                  ),
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
                Column(
                  // Stack the buttons vertically
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Center the buttons
                  children: [
                    SizedBox(
                      width: 200, // Set a specific width for the button
                      child: UploadButton(
                        buttonLabel: 'Upload your cover',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CoverUploadPage()),
                          );
                        },
                        backgroundColor: const Color(0xFFBFA054),
                        foregroundColor: const Color(0xFF2F2F2F),
                        icon: const Icon(
                          CupertinoIcons.add,
                          size: 22,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0), // Add spacing between buttons
                    SizedBox(
                      width: 200, // Set a specific width for the button
                      child: UploadButton(
                        buttonLabel: 'Upload your art',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ArtUploadPage()),
                          );
                        },
                        backgroundColor: const Color(0xFF2F2F2F),
                        foregroundColor: const Color(0xFFFBF8F2),
                        icon: const Icon(
                          CupertinoIcons.add,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPortraitLayout() {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0, top: 8.0),
      child: Column(
        children: [
          // Thumbnail
          Row(
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
                              placeholder:
                                  'images/search_placeholder_image.jpg',
                              image: widget.book.thumbnailUrl,
                              fit: BoxFit.cover,
                              imageErrorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return Image.asset(
                                  'images/search_placeholder_image.jpg',
                                  fit: BoxFit.cover,
                                );
                              },
                            )
                          : Image.asset(
                              'images/search_placeholder_image.jpg',
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Centered title and follow icon
                    Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 8.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.book.title,
                                style: GoogleFonts.dmSerifDisplay(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(width: 8.0), // Add spacing
                              GestureDetector(
                                onTap: _toggleSaveBook,
                                child: Icon(
                                  isBookSaved ? Icons.check : Icons.add,
                                  size: 30,
                                  color: isBookSaved
                                      ? const Color(0xFFBFA054)
                                      : const Color(0xFF2F2F2F),
                                ),
                              ),
                            ],
                          ),
                          Text(" by ${widget.book.author}"),
                        ],
                      ),
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
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          child: UploadButton(
                            buttonLabel: 'Upload your cover',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CoverUploadPage(),
                                ),
                              );
                            },
                            backgroundColor: const Color(0xFFBFA054),
                            foregroundColor: const Color(0xFF2F2F2F),
                            icon: const Icon(
                              CupertinoIcons.add,
                              size: 22,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        SizedBox(
                          width: 200,
                          child: UploadButton(
                            buttonLabel: 'Upload your art',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ArtUploadPage(),
                                ),
                              );
                            },
                            backgroundColor: const Color(0xFF2F2F2F),
                            foregroundColor: const Color(0xFFFBF8F2),
                            icon: const Icon(
                              CupertinoIcons.add,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
