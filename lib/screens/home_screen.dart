import 'package:bookartify/services/database_api.dart';
import 'package:bookartify/widgets/icons_and_buttons/save_icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bookartify/widgets/icons_and_buttons/share_button.dart';
import 'package:bookartify/widgets/icons_and_buttons/like_icon.dart';
import 'package:bookartify/widgets/search/inactive_searchbar.dart';

/*
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(
                        bottom: 16.0), // Add margin between cards
                    child: _buildCard(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard() {
    const artTitle = 'Art Work Title';
    const artist = 'Artist Name';
    const image = 'images/forYouSample.jpg';

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
              child: Image.asset(
                image,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    artTitle,
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
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'By $artist',
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
*/

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? currentUser;
  List<dynamic> _forYou = [];

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
        _forYou = fetchedForYou ?? [];
      });
    }
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
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
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
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'By ${_forYou[index]["user_id"].toString()}',
                              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
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
        ],
      ),
    );
  }
}



