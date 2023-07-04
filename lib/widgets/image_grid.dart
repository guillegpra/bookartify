import 'package:bookartify/is_tablet.dart';
import 'package:bookartify/widgets/post_widget.dart';
import 'package:flutter/material.dart';

class ImageGrid extends StatelessWidget {
  final List<String> _imagePaths;
  final List<String> _imageTitles;

  const ImageGrid({super.key, required List<String> imagePaths, required List<String> imageTitles}) : _imageTitles = imageTitles, _imagePaths = imagePaths;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: _imagePaths.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: !isTablet(context) ? 2 : 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.75, // Adjust this value for desired aspect ratio
      ),
      itemBuilder: (BuildContext context, int index) {
        return PostWidget(
          path: _imagePaths[index],
          title: _imageTitles[index],
        );
      });
  }
}
