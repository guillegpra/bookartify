import 'package:bookartify/is_tablet.dart';
import 'package:bookartify/services/google_books_api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bookartify/screens/art_solo.dart';
import 'package:bookartify/models/book_search.dart';

class PostWidget extends StatelessWidget {
  // final String path;
  // final String title;
  // final String bookId;
  // final String userId;
  final dynamic post;

  // const PostWidget(
  //     {Key? key,
  //     /* required this.width, */
  //     required this.path,
  //     required this.title,
  //     required this.bookId,
  //     required this.userId})
  //     : super(key: key);

  const PostWidget({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Book>(
      future: GoogleBooksApi().getBookFromId(post["book_id"]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for the future to complete, show a loading indicator.
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // If there's an error in fetching the book data, show an error message.
          return const Text('Error loading book data');
        } else if (snapshot.hasData) {
          // If the future is complete and data is available, build the UI.
          Book book = snapshot.data!;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArtSoloScreen(
                      imagePath: post["url"],
                      imageTitle: post["title"],
                      book: book,
                      userId: post["user_id"]),
                ),
              );
            },
            child: Container(
              // width: width,
              // height: 250,
              decoration: BoxDecoration(
                  color: const Color(0xFFF5EFE1),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: !isTablet(context)
                    ? const EdgeInsets.all(10.0)
                    : const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: Image.network(
                          post["url"],
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      post["title"],
                      style: GoogleFonts.dmSerifDisplay(
                          fontSize: !isTablet(context) ? 16 : 20,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          );
        } else {
          // If there's no data, show an empty container.
          return Container();
        }
      },
    );
  }
}
