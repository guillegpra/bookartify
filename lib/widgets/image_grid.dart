import 'package:flutter/material.dart';
import 'package:bookartify/is_tablet.dart';
import 'package:bookartify/widgets/post_widget.dart';
import 'package:bookartify/screens/art_solo.dart';

class ImageGrid extends StatelessWidget {
  final List<String> _imagePaths;
  final List<String> _imageTitles;

  const ImageGrid({
    Key? key,
    required List<String> imagePaths,
    required List<String> imageTitles,
  })  : _imageTitles = imageTitles,
        _imagePaths = imagePaths,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: _imagePaths.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: !isTablet(context) ? 2 : 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.85, // Adjust this value for desired aspect ratio
      ),
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            // Navigate to the detail screen when an image is tapped
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ArtSoloScreen(
                  imagePath: _imagePaths[index],
                  imageTitle: _imageTitles[index],
                ),
              ),
            );
          },
          child: PostWidget(
            path: _imagePaths[index],
            title: _imageTitles[index],
          ),
        );
      },
    );
  }
}
