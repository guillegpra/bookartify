import 'package:bookartify/widgets/icons_and_buttons/save_icon.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bookartify/widgets/icons_and_buttons/share_button.dart';
import 'package:bookartify/widgets/icons_and_buttons/like_icon.dart';
import 'package:bookartify/widgets/inactive_searchbar.dart';

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
    final artTitle = 'Art Work Title';
    final artist = 'Artist Name';
    final image = 'images/forYouSample.jpg';

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








//old code before searchbar implementation
// import 'package:bookartify/widgets/save_icon.dart';
// import 'package:bookartify/widgets/search_bar.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:bookartify/widgets/share_button.dart';
// import 'package:bookartify/widgets/like_icon.dart';
// import 'package:bookartify/widgets/save_icon.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: const SearchScanBar(),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Container(
//               decoration: BoxDecoration(
//                 color: const Color.fromRGBO(245, 239, 225, 1),
//                 borderRadius: BorderRadius.circular(8.0),
//                 border: Border.all(
//                   color: const Color.fromRGBO(191, 160, 84, 1),
//                   width: 2.0,
//                 ),
//               ),
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 "For You",
//                 style: GoogleFonts.poppins(
//                   fontSize: 18,
//                   color: const Color.fromRGBO(47, 47, 47, 1),
//                 ),
//               ),
//             ),
//           ),
//           Flexible(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 10.0),
//               child: ListView.builder(
//                 itemCount: 3,
//                 itemBuilder: (context, index) {
//                   return Container(
//                     margin: const EdgeInsets.only(
//                         bottom: 16.0), // Add margin between cards
//                     child: Card(
//                       color: const Color.fromRGBO(245, 239, 225, 1),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(10),
//                               child: Image.asset(
//                                 'images/forYouSample.jpg',
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: [
//                                 Expanded(
//                                   child: Text(
//                                     'Art Work Title',
//                                     style: GoogleFonts.dmSerifDisplay(
//                                         fontSize: 18),
//                                   ),
//                                 ),
//                                 SizedBox(width: 8.0),
//                                 LikeIcon(),
//                                 SizedBox(width: 8.0),
//                                 SaveIcon(),
//                                 SizedBox(width: 8.0),
//                                 ShareButton(onPressed: () {
//                                   // TODO: share functionality
//                                 }),
//                               ],
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Text(
//                               'By artist name',
//                               style: GoogleFonts.poppins(
//                                   fontSize: 14, color: Colors.grey),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



