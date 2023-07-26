import 'package:bookartify/models/book_search.dart';
import 'package:bookartify/screens/book_screen.dart';
import 'package:bookartify/services/api_service.dart';
import 'package:bookartify/services/database_api.dart';
import 'package:bookartify/widgets/icons_and_buttons/save_icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bookartify/widgets/icons_and_buttons/share_button.dart';
import 'package:bookartify/widgets/icons_and_buttons/like_icon.dart';
import 'package:bookartify/widgets/search/inactive_searchbar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? currentUser;
  final _apiService = ApiService();
  List<dynamic> _forYou = [];
  List<Book> _books = [];

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    _fetchForYou();
  }

  Future<void> _fetchForYou() async {
    if (currentUser != null) {
      List<dynamic> fetchedForYou = await getForYouByUser(currentUser!.uid);
      setState(() {
        _forYou = fetchedForYou;
      });

      await _fetchBooksForYou();
    }
  }

  Future<void> _fetchBooksForYou() async {
    List<Book> books = [];

    for (var item in _forYou) {
      String bookId = item["book_id"].toString();
      Book? book = await _apiService.getBookFromId(bookId);
      if (book != null) {
        print(book.description);
        books.add(book);
      }
    }

    setState(() {
      _books = books;
    });
  }

  Future<void> _reloadData() async {
    // Fetch the data again and update the state
    await _fetchForYou();
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
                onRefresh: _reloadData,
                child: ListView.builder(
                  itemCount: _forYou.length,
                  itemBuilder: (context, index) {
                    if (_forYou.isEmpty) {
                      return const Text("No posts yet. Follow books and users on the Explore page.");
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
                                  _forYou[index]["url"].toString(),
                                  loadingBuilder: (BuildContext context, Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
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
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Expanded(
                                    child: Text(
                                      _forYou[index]["title"].toString(),
                                      style: GoogleFonts.dmSerifDisplay(fontSize: 18),
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  const LikeIcon(),
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
                              padding: const EdgeInsets.fromLTRB(10.0, 8.0, 10.0, 1.0),
                              child: Text(
                                'By ${_forYou[index]["user_id"].toString()}',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500
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
                                      text: _books.isNotEmpty ? _books[index].title : "",
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
                                              builder: (context) => BookScreen(
                                                book: _books[index],
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
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



