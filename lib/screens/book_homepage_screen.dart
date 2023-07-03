import 'package:bookartify/widgets/release_and_pagesinfo.dart';
import 'package:bookartify/widgets/save_icon.dart';
import 'package:bookartify/widgets/upload_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/art_tabbar_view.dart';

class BookPageHome extends StatelessWidget {
  const BookPageHome({super.key});

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            print('To be worked!!');
          },
        ),
      ),
      body: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 10, 10.0, 10.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width *
                      0.45, // Take up 45% of the screen width
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.asset('images/fanart.jpg',
                          fit: BoxFit.fitHeight)),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Book Title',
                              style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                            Text(
                              'By Author Name',
                              style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 15),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: SaveIcon(),
                          ),
                        ),
                      ],
                    ),

                    //RELEASED DATE AND BOOK PAGES INFO
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InfoContainer(
                              title: 'Released',
                              bookInfo: 'April 2022',
                            ),
                            InfoContainer(
                              title: 'Pages',
                              bookInfo: '300',
                            ),
                          ],
                        ),
                      ),
                    ),

                    //UPLOAD BUTTONS
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 5, 15, 0),
                      child: Column(
                        children: [
                          UploadButton(
                            buttonLabel: 'Upload Cover',
                            onPressed: () {},
                            backgroundColor:
                                const Color.fromARGB(255, 192, 162, 73),
                            foregroundColor:
                                const Color.fromARGB(255, 47, 47, 47),
                            icon: const Icon(
                              CupertinoIcons.cloud,
                              size: 26,
                            ),
                          ),
                          UploadButton(
                            buttonLabel: 'Upload Cover',
                            onPressed: () {},
                            backgroundColor:
                                const Color.fromARGB(255, 47, 47, 47),
                            foregroundColor:
                                const Color.fromARGB(255, 192, 162, 73),
                            icon: const Icon(
                              CupertinoIcons.cloud,
                              size: 26,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Expanded(
            child: ArtTabView(),
          ),
        ],
      ),
    );
  }
}
