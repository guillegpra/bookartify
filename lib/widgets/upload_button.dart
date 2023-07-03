//UPLOAD BUTTON WITH ANIMATION
import 'package:flutter/material.dart';

class UploadButton extends StatefulWidget {
  const UploadButton({
    Key? key,
    required this.buttonLabel,
    required this.onPressed,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.icon,
  }) : super(key: key);

  final String buttonLabel;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final Icon icon;

  @override
  _UploadButtonState createState() => _UploadButtonState();
}

class _UploadButtonState extends State<UploadButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _animation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: GestureDetector(
        onTapDown: (TapDownDetails details) {
          _controller.forward();
        },
        onTapUp: (TapUpDetails details) {
          _controller.reverse();
        },
        onTapCancel: () {
          _controller.reverse();
        },
        child: ScaleTransition(
          scale: _animation,
          child: ElevatedButton(
            onPressed: widget.onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: widget.backgroundColor,
              foregroundColor: widget.foregroundColor,
            ),
            child: Row(
              children: [
                Expanded(flex: 2, child: widget.icon),
                Expanded(
                  flex: 8,
                  child: Text(
                    widget.buttonLabel,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



//UPLOAD BUTTON WITHOUT ANIMATION
// import 'package:flutter/material.dart';

// class UploadButton extends StatelessWidget {
//   const UploadButton({
//     super.key,
//     required this.buttonLabel,
//     required this.onPressed,
//     required this.backgroundColor,
//     required this.foregroundColor,
//     required this.icon,
//   });

//   final String buttonLabel;
//   final VoidCallback onPressed;
//   final Color backgroundColor;
//   final Color foregroundColor;
//   final Icon icon;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       child: ElevatedButton(
//         onPressed: onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: backgroundColor,
//           foregroundColor: foregroundColor,
//         ),
//         child: Row(
//           children: [
//             Expanded(flex: 2, child: icon),
//             Expanded(
//               flex: 8,
//               child: Text(
//                 buttonLabel,
//                 style: const TextStyle(fontSize: 16),
//                 textAlign: TextAlign.center,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }