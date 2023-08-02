import 'package:bookartify/models/book_search.dart';
import 'package:bookartify/widgets/info_box.dart';
import 'package:bookartify/widgets/upload_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookInfoTablet extends StatefulWidget {
  final Book book;

  const BookInfoTablet({Key? key, required this.book}) : super(key: key);

  @override
  _BookInfoTabletState createState() => _BookInfoTabletState();
}

class _BookInfoTabletState extends State<BookInfoTablet> {
  bool isBookSaved = false;
  final currentUser = FirebaseAuth.instance.currentUser;

  String formatDate(String date) {
    if (date.length == 10) {
      return DateFormat('dd-MM-yyyy')
          .format(DateFormat('yyyy-MM-dd').parse(date));
    } else {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0, top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.20,
              decoration: BoxDecoration(
                color: const Color(0xFFF5EFE1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  widget.book.thumbnailUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  // Wrapping title and author with a Row
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(left: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              widget.book.title,
                              style: GoogleFonts.dmSerifDisplay(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "by " + widget.book.author,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isBookSaved = !isBookSaved;
                        });
                      },
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
                const SizedBox(height: 8.0),
                Center(
                  // Centering the release date and pages
                  child: Row(
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
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Text(
              parseFragment(widget.book.description).text ?? "",
              maxLines: 20,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: GoogleFonts.poppins(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
