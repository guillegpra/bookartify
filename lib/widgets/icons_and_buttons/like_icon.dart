//SAVE ICON WITH ANIMATION
import 'package:bookartify/services/database_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LikeIcon extends StatefulWidget {
  final String type;
  final String id;
  const LikeIcon({Key? key, required this.type, required this.id}) : super(key: key);

  @override
  State<LikeIcon> createState() => _LikeIconState();
}

class _LikeIconState extends State<LikeIcon> {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    getLikedStatus();
  }

  Future<void> getLikedStatus() async {
    bool liked = (widget.type == "art") ? await isLikedArt(userId, widget.id)
      : await isLikedCover(userId, widget.id);

    setState(() {
      isLiked = liked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.type == "art" && !isLiked) {
          await likeArt(userId, widget.id);
        } else if (widget.type == "art" && isLiked) {
          await unlikeArt(userId, widget.id);
        } else if (widget.type == "cover" && !isLiked) {
          await likeCover(userId, widget.id);
        } else {
          await unlikeCover(userId, widget.id);
        }

        setState(() {
          isLiked = !isLiked;
        });
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: Icon(
          isLiked ? Icons.favorite : Icons.favorite_border,
          key: ValueKey<bool>(isLiked), // Unique key to trigger the animation
          color: Colors.black,
        ),
      ),
    );
  }
}


