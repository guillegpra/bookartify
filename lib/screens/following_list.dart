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

  const FollowingListScreen({super.key, required this.userId});

  @override
  State<FollowingListScreen> createState() => _FollowingListScreenState();
}

class _FollowingListScreenState extends State<FollowingListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GoogleBooksApi _googleBooksApi = GoogleBooksApi();
  List<dynamic> _followingArtists = [];
  List<Book> _followingBooks = [];
  Future<List<String>>? _followingArtistsFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _followingArtistsFuture = _fetchFollowingArtists();
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

      setState(() {
        _followingArtists =
            artistIds; // Assign the fetched artist IDs to _followingArtists
      });

      print(
          "Following artists IDs: $_followingArtists"); // Check if the artist IDs are correct

      List<String> artistNames = [];
      for (String artistId in artistIds) {
        String? username = await getUsername(artistId);
        if (username != null) {
          artistNames.add(username);
        }
      }

      print(
          "Following artist names: $artistNames"); // Check if the artist names are correct

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
            indicatorColor: const Color(0xFF8A6245),
            tabs: const [
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
                RefreshIndicator(
                  onRefresh: _fetchFollowingBooks,
                  child: _buildBooksTab()
                ),
                RefreshIndicator(
                  onRefresh: _fetchFollowingArtists,
                  child: _buildArtistsTab()
                ),
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

        return GestureDetector(
          onTap: () {
            _navigateToBookScreen(book);
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 2.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(42),
                color: const Color.fromARGB(70, 192, 162, 73),
              ),
              child: ListTile(
                leading: GestureDetector(
                  onTap: () {
                    _navigateToBookScreen(book);
                  },
                  child: Container(
                    width: 60,
                    height: 90,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: NetworkImage(thumbnailUrl),
                        fit: BoxFit.contain, // Use BoxFit.contain here
                      ),
                    ),
                  ),
                ),
                title: Text(
                  title,
                  style: GoogleFonts.dmSerifDisplay(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  author,
                  style: GoogleFonts.poppins(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      // TODO
                      print("pressed");
                    },
                    child: const Icon(Icons.add), // TODO: follow/unfollow from here
                  ),
                ),
              ),
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
    return FutureBuilder<List<String>>(
      future: _followingArtistsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text("Error fetching data"),
          );
        } else {
          List<String> artistNames = snapshot.data ?? [];

          if (artistNames.isEmpty) {
            return const Center(
              child: Text("No artists followed yet."),
            );
          }

          return ListView.builder(
            itemCount: artistNames.length,
            itemBuilder: (context, index) {
              String artistUserId = _followingArtists[index];
              String artistName = artistNames[index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(42),
                    color: const Color.fromARGB(70, 192, 162, 73),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: GestureDetector(
                      onTap: () {
                        _navigateToUserProfileScreen(artistUserId);
                      },
                      child: Text(
                        artistName,
                        style: GoogleFonts.dmSerifDisplay(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
