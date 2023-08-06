import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bookartify/services/database_api.dart';
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
  List<bool> _isFollowingBookList = [];
  List<bool> _isFollowingArtistList = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // _followingArtistsFuture = _fetchFollowingArtists();
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
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;

      List<dynamic> followingBooks =
          await getFollowingBooksByUser(widget.userId);
      List<dynamic> bookIds =
          followingBooks.map((book) => book["following_id"]).toList();

      List<Book> books = [];
      List<bool> isFollowingBookList = [];
      for (String bookId in bookIds) {
        Book book = await _googleBooksApi.getBookFromId(bookId);
        books.add(book);

        bool isFollowingBookAux = await isFollowingBook(currentUserId, bookId);
        isFollowingBookList.add(isFollowingBookAux);
      }

      setState(() {
        _followingBooks = books;
        _isFollowingBookList = isFollowingBookList;
      });
    } catch (e) {
      print("Error fetching following books: $e");
    }
  }

  Future<List<String>> _fetchFollowingArtists() async {
    try {
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;

      List<dynamic> followingArtists =
          await getFollowingArtistsByUser(widget.userId);
      List<dynamic> artistIds =
          followingArtists.map((artist) => artist["following_id"]).toList();

      List<bool> isFollowingArtistList = [];

      print(
          "Following artists IDs: $artistIds"); // Check if the artist IDs are correct

      List<String> artistNames = [];
      for (String artistId in artistIds) {
        String? username = await getUsername(artistId);
        if (username != null) {
          artistNames.add(username);
        }

        // check if current user is following them
        bool isFollowingArtistAux = await isFollowingUser(currentUserId, artistId);
        isFollowingArtistList.add(isFollowingArtistAux);
      }

      setState(() {
        _followingArtists =
            artistIds; // Assign the fetched artist IDs to _followingArtists
        _isFollowingArtistList = isFollowingArtistList;
      });

      print(
          "Following artist names: $artistNames"); // Check if the artist names are correct

      return artistNames;
    } catch (e) {
      print("Error fetching following artists: $e");
      return []; // Return an empty list in case of an error
    }
  }

  void _toggleSaveBook(bool isSaved, String bookId, int index) async {
    // Get the current user's ID
    String currentUserID = FirebaseAuth.instance.currentUser!.uid;

    try {
      if (isSaved) {
        // If the book is saved, unfollow it
        await unfollowBook(currentUserID, bookId);
        print("Unfollowed book response: Success");
      } else {
        // If the book is not saved, follow it
        await followBook(currentUserID, bookId);
        print("Followed book response: Success");
      }

      // Toggle the icon state after successful follow/unfollow
      setState(() {
        _isFollowingBookList[index] = !_isFollowingBookList[index];
      });
    } catch (e) {
      // Handle any errors that occur during the operation
      print("Error saving/unfollowing book: $e");
      // // Revert the 'isBookSaved' state to its original value if an error occurs
      // setState(() {
      //   isSaved = !isSaved;
      // });
    }
  }

  void _toggleFollowingUser(bool isFollowing, String userId, int index) async {
    // Get the current user's ID
    String currentUserID = FirebaseAuth.instance.currentUser!.uid;

    try {
      if (isFollowing) {
        await unfollowUser(currentUserID, userId);
        print("Unfollowed user response: Success");
      } else {
        await followUser(currentUserID, userId);
        print("Followed user response: Success");
      }

      // Toggle the icon state after successful follow/unfollow
      setState(() {
        _isFollowingArtistList[index] = !_isFollowingArtistList[index];
      });
    } catch (e) {
      // Handle any errors that occur during the operation
      print("Error saving/unfollowing user: $e");
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
                text: "Users",
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
                  onRefresh: () async {
                    await _fetchFollowingArtists();
                    _buildArtistsTab();
                  },
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
        String bookId = book.id;
        String title = book.title;
        String author = book.author;
        String thumbnailUrl = book.thumbnailUrl;

        bool isFollowing = _isFollowingBookList[index];

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
                      _toggleSaveBook(isFollowing, bookId, index);
                    },
                    child: Icon(
                      isFollowing ? Icons.check : Icons.add,
                      size: 30,
                      color: isFollowing
                          ? const Color(0xFFBFA054)
                          : const Color(0xFF2F2F2F),
                    ),
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

          if (artistNames.isEmpty || !snapshot.hasData) {
            return const Center(
              child: Text("No users followed yet."),
            );
          }

          return ListView.builder(
            itemCount: artistNames.length,
            itemBuilder: (context, index) {
              String artistUserId = _followingArtists[index];
              String artistName = artistNames[index];
              bool isFollowing = _isFollowingArtistList[index];
              print("is following: $isFollowing");

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
                    trailing: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          _toggleFollowingUser(isFollowing, artistUserId, index);
                        },
                        child: Icon(
                          isFollowing ? Icons.check : Icons.add,
                          size: 30,
                          color: isFollowing
                              ? const Color(0xFFBFA054)
                              : const Color(0xFF2F2F2F),
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
