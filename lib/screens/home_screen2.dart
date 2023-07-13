import 'package:bookartify/services/storage.dart';
import 'package:bookartify/widgets/icons_and_buttons/save_icon.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bookartify/widgets/icons_and_buttons/share_button.dart';
import 'package:bookartify/widgets/icons_and_buttons/like_icon.dart';
import 'package:bookartify/widgets/search/inactive_searchbar.dart';

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({super.key});

  @override
  State<HomeScreen2> createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2> {
  final Storage storage = Storage();

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
              child: FutureBuilder<ListResult>(
                future: storage.listFiles(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Display a loading indicator
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    // Display an error message
                    return Text("Error: ${snapshot.error}");
                  } else if (snapshot.hasData) {
                    // Build the ListView.builder using the retrieved list
                    return ListView.builder(
                        itemCount: snapshot.data!.items.length,
                        itemBuilder: (context, index) {
                          return FutureBuilder(
                              future: storage.downloadUrl(snapshot.data!.items[index].name),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text("Error: ${snapshot.error}");
                                } else if (snapshot.hasData) {
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
                                              snapshot.data!,
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
                                                  "Title",
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
                                            'By someone',
                                            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  // Handle the case where the URL is null
                                  return Text("No URL available");
                                }
                              }
                          );
                        }
                    );
                  } else {
                    // Handle the case where the data is null
                    return Text("No data available");
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
