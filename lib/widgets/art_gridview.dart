import 'package:bookartify/data/dummy_art_data.dart';
import 'package:bookartify/widgets/art_image_container.dart';
import 'package:flutter/material.dart';
class ArtGridView extends StatelessWidget {
  const ArtGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12,12,12,12),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 / 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 18,
        ),
        itemCount: artworksForThatBook.length,
        itemBuilder: (ctx, i) =>
            ArtImageContainer(artwork: artworksForThatBook[i]),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
      ),
    );
  }
}


// import 'package:bookartify/data/dummy_art_data.dart';
// import 'package:bookartify/widgets/art_image_container.dart';
// import 'package:flutter/material.dart';

// class ArtGridView extends StatelessWidget {
//   const ArtGridView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(12,16,12,12),
//       child: GridView.builder(
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           childAspectRatio: 2 / 3,
//           crossAxisSpacing: 12,
//           mainAxisSpacing: 18,
//         ),
//         itemCount: artworksForThatBook.length,
//         itemBuilder: (ctx, i) =>
//             ArtImageContainer(artwork: artworksForThatBook[i]),
//       ),
//     );
//   }
// }
