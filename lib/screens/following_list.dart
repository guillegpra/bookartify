import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bookartify/services/database_api.dart';
import 'package:bookartify/widgets/profile/user_widget.dart';
import 'package:bookartify/services/google_books_api.dart';
import 'package:bookartify/models/book_search.dart';
import 'package:bookartify/screens/book_screen.dart';
import 'package:bookartify/services/usernames_db.dart';
import 'package:bookartify/screens/profile_screen.dart';

class FollowingListScreen extends StatefulWidget {
  final String userId;

  FollowingListScreen({required this.userId});
  @override
  _FollowingListScreenState createState() => _FollowingListScreenState();
}

class _FollowingListScreenState extends State<FollowingListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GoogleBooksApi _googleBooksApi = GoogleBooksApi();
  List<dynamic> _followingArtists = [];
  List<Book> _followingBooks = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchFollowingArtists();
    _fetchFollowingBooks();
  }

  void _navigateToUserProfileScreen(String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(userId: userId),
      ),
    );
  }

  Future<void> _fetchFollowingBooks() async {
    try {
      List<dynamic> followingBooks =
          await getFollowingBooksByUser(widget.userId);
      List<dynamic> bookIds =
          followingBooks.map((book) => book["following_id"]).toList();

      List<Book> books = [];
      for (String bookId in bookIds) {
        Book book = await _googleBooksApi.getBookFromId(bookId);
        books.add(book);
      }

      setState(() {
        _followingBooks = books;
      });
    } catch (e) {
      print("Error fetching following books: $e");
    }
  }

  Future<List<String>> _fetchFollowingArtists() async {
    try {
      List<dynamic> followingArtists =
          await getFollowingArtistsByUser(widget.userId);
      List<dynamic> artistIds =
          followingArtists.map((artist) => artist["following_id"]).toList();

      List<String> artistNames = [];
      for (String artistId in artistIds) {
        String? username = await getUsername(artistId);
        if (username != null) {
          artistNames.add(username);
        }
      }

      return artistNames;
    } catch (e) {
      print("Error fetching following artists: $e");
      return []; // Return an empty list in case of an error
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
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
          "Following",
          style: GoogleFonts.dmSerifDisplay(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            indicatorColor: Color(0xFF8A6245),
            tabs: [
              Tab(
                icon: Icon(Icons.book),
                text: "Books",
              ),
              Tab(
                icon: Icon(Icons.person),
                text: "Artists",
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBooksTab(),
                _buildArtistsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBooksTab() {
    return ListView.builder(
      itemCount: _followingBooks.length,
      itemBuilder: (context, index) {
        Book book = _followingBooks[index];
        String title = book.title;
        String author = book.author;
        String thumbnailUrl = book.thumbnailUrl;

        return ListTile(
          leading: GestureDetector(
            onTap: () {
              _navigateToBookScreen(book);
            },
            child: Container(
              width: 60,
              height: 90,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(thumbnailUrl),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          title: GestureDetector(
            onTap: () {
              _navigateToBookScreen(book);
            },
            child: Text(
              title,
              style: GoogleFonts.poppins(),
            ),
          ),
          subtitle: GestureDetector(
            onTap: () {
              _navigateToBookScreen(book);
            },
            child: Text(
              author,
              style: GoogleFonts.poppins(),
            ),
          ),
        );
      },
    );
  }

  void _navigateToBookScreen(Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookScreen(book: book),
      ),
    );
  }

  Widget _buildArtistsTab() {
    return FutureBuilder(
      future: _fetchFollowingArtists(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Error fetching data"),
          );
        } else {
          List<String> artistNames = snapshot.data as List<String>;

          return ListView.builder(
            itemCount: artistNames.length,
            itemBuilder: (context, index) {
              String artistUserId =
                  _followingArtists[index]; // Get the artist's user ID
              String artistName = artistNames[index]; // Get the artist's name

              return ListTile(
                leading: Icon(Icons.person),
                title: GestureDetector(
                  onTap: () {
                    _navigateToUserProfileScreen(artistUserId);
                  },
                  child: Text(
                    artistName,
                    style: GoogleFonts.poppins(),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
