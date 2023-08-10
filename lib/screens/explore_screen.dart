import 'package:bookartify/is_tablet.dart';
import 'package:bookartify/widgets/search/inactive_searchbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bookartify/screens/viewmore_screen.dart';
import 'package:bookartify/models/book_model.dart';
import 'package:bookartify/services/database_api.dart' as database_api;
import 'package:bookartify/services/google_books_api.dart';
import 'package:bookartify/widgets/explore_genre_posts.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late Future<List<Map<String, dynamic>>> futurePosts;
  late List<int> bookIds;
  final _googleBooksAPI = GoogleBooksApi();

  @override
  void initState() {
    super.initState();
    futurePosts = _getPostsAndBooks();
  }

  Future<Book?> getBookById(String bookId) async {
    // Use the GoogleBooksApi instance to get the book using its bookId
    Book? book = await _googleBooksAPI.getBookFromId(bookId);
    return book;
  }

  Future<List<Map<String, dynamic>>> _getPostsAndBooks() async {
    List<Map<String, dynamic>> posts = await database_api.getAllPosts();
    for (var post in posts) {
      String bookId = post['book_id'];
      post['book_details'] = await getBookById(bookId);
      // Fetch and set the username for each post based on the user_id
      post['username'] = await database_api.getUsernameById(post['user_id']);
    }

    // Sort the posts based on 'book_category'
    posts.sort((a, b) =>
        (a['book_category'] as String).compareTo(b['book_category'] as String));

    return posts;
  }

  Map<String, List<Map<String, dynamic>>> groupPostsByCategory(
      List<Map<String, dynamic>> posts) {
    Map<String, List<Map<String, dynamic>>> categoryMap = {};

    for (var post in posts) {
      String category = post['book_category'];
      if (categoryMap.containsKey(category)) {
        categoryMap[category]!.add(post);
      } else {
        categoryMap[category] = [post];
      }
    }

    return categoryMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: InactiveSearchBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: futurePosts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No data found.'));
            }

            // Group posts by category
            var groupedPosts = groupPostsByCategory(snapshot.data!);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: groupedPosts.entries.map((entry) {
                // Here, entry.key is the category and entry.value is the list of posts in that category.
                String genre = entry.key;

                return _buildGridSection(genre, entry.value, context);
              }).toList(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGridSection(
      String genre, List<Map<String, dynamic>> posts, BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 3),
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5EFE1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color.fromARGB(255, 192, 162, 73),
                    width: 1.0, // <-- Change this to adjust border width
                  ),
                ),
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  genre,
                  style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: const Color.fromARGB(255, 47, 47, 1),
                      fontWeight: FontWeight.normal),
                ),
              ),
            ),
            Container(
              height: (MediaQuery.of(context).size.width /
                  1.7), // Considering 2 rows and each item having aspect ratio close to 1
              child: explore_genre(
                types: List.generate(posts.length,
                    (index) => genre), // Generate genre for each post
                posts: posts.take(4).toList(), // Take only 4 posts maximum
              ),
            ),
            if (posts.length >
                4) // This condition checks if there are more than 4 posts
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 47, 47, 1),
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewMoreScreen(
                                genre: genre,
                                posts:
                                    posts, // Pass the list of posts of the chosen genre
                              ),
                            ),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          child: Text(
                            'View More',
                            style: TextStyle(
                              color: Colors
                                  .white, // Changed the text color for better visibility on the button background
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ));
  }
}
