//SAVE ICON WITH ANIMATION
import 'package:bookartify/services/database_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SaveIcon extends StatefulWidget {
  final String type;
  final String id;

  const SaveIcon({Key? key, required this.type, required this.id}) : super(key: key);

  @override
  State<SaveIcon> createState() => _SaveIconState();
}

class _SaveIconState extends State<SaveIcon> {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    getSavedStatus();
  }

  Future<void> getSavedStatus() async {
    bool saved = (widget.type == "art") ? await isBookmarkedArt(userId, widget.id)
        : await isBookmarkedCover(userId, widget.id);

    setState(() {
      isSaved = saved;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.type == "art" && !isSaved) {
          await bookmarkArt(userId, widget.id);
        } else if (widget.type == "art" && isSaved) {
          await unbookmarkArt(userId, widget.id);
        } else if (widget.type == "cover" && !isSaved) {
          await bookmarkCover(userId, widget.id);
        } else {
          await unbookmarkCover(userId, widget.id);
        }

        setState(() {
          isSaved = !isSaved;
        });
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: Icon(
          isSaved ? Icons.bookmark : Icons.bookmark_border,
          key: ValueKey<bool>(isSaved), // Unique key to trigger the animation
          color: Colors.black,
        ),
      ),
    );
  }
}


