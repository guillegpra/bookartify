//SAVE ICON WITH ANIMATION
import 'package:flutter/material.dart';

class SaveIcon extends StatefulWidget {
  const SaveIcon({Key? key}) : super(key: key);

  @override
  _SaveIconState createState() => _SaveIconState();
}

class _SaveIconState extends State<SaveIcon> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isTapped = !isTapped;
        });
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(child: child, scale: animation);
        },
        child: Icon(
          isTapped ? Icons.bookmark : Icons.bookmark_border,
          key: ValueKey<bool>(isTapped), // Unique key to trigger the animation
          color: Colors.black,
        ),
      ),
    );
  }
}



//SAVE ICON WITHOUT ANIMATION
// import 'package:flutter/material.dart';

// class SaveIcon extends StatefulWidget {
//   const SaveIcon({Key? key}) : super(key: key);

//   @override
//   _SaveIconState createState() => _SaveIconState();
// }

// class _SaveIconState extends State<SaveIcon> {
//   bool isTapped = false;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           isTapped = !isTapped;
//         });
//       },
//       child: Icon(
//         isTapped ? Icons.bookmark : Icons.bookmark_border,
//         color: isTapped ? Colors.black : Colors.black,
//       ),
//     );
//   }
// }

