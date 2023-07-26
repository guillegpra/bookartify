import 'package:bookartify/is_tablet.dart';
import 'package:bookartify/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bookartify/screens/art_solo.dart';
import 'package:bookartify/models/book_search.dart';

class PostWidget extends StatelessWidget {
  // final double width;
  final String path;
  final String title;
  final String bookId;
  final String userId;

  const PostWidget(
      {Key? key,
      /* required this.width, */
      required this.path,
      required this.title,
      required this.bookId,
      required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Book>(
      future: ApiService().getBookFromId(bookId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for the future to complete, show a loading indicator.
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // If there's an error in fetching the book data, show an error message.
          return Text('Error loading book data');
        } else if (snapshot.hasData) {
          // If the future is complete and data is available, build the UI.
          Book book = snapshot.data!;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ArtSoloScreen(
                      imagePath: path,
                      imageTitle: title,
                      book: book,
                      userId: userId),
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
                          path,
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
                      title,
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
