import 'package:flutter/material.dart';
import 'package:bookartify/is_tablet.dart';
import 'package:bookartify/widgets/post_widget.dart';

class explore_genre extends StatelessWidget {
  final List<String> types;
  final List<dynamic> posts;

  const explore_genre({Key? key, required this.types, required this.posts})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: posts.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.45,
            child: PostWidget(
              type: types[index],
              post: posts[index],
            ),
          ),
        );
      },
    );
  }
}
