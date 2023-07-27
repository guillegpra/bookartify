import 'package:flutter/material.dart';
import 'package:bookartify/is_tablet.dart';
import 'package:bookartify/widgets/post_widget.dart';

class ImageGrid extends StatelessWidget {
  final List<dynamic> posts;
  // final List<String> _imagePaths;
  // final List<String> _imageTitles;
  // final List<String> _bookIds;
  // final List<String> _userIds;

  // const ImageGrid(
  //     {Key? key,
  //     required List<String> imagePaths,
  //     required List<String> imageTitles,
  //     required List<String> bookIds,
  //     required List<String> userIds})
  //     : _imageTitles = imageTitles,
  //       _imagePaths = imagePaths,
  //       _bookIds = bookIds,
  //       _userIds = userIds,
  //       super(key: key);
  const ImageGrid({Key? key, required this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: posts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: !isTablet(context) ? 2 : 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.85, // Adjust this value for desired aspect ratio
      ),
      itemBuilder: (BuildContext context, int index) {
        return PostWidget(
          // path: _imagePaths[index],
          // title: _imageTitles[index],
          // bookId: _bookIds[index],
          // userId: _userIds[index],
          post: posts[index],
        );
      },
    );
  }
}
