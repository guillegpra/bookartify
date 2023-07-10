import 'package:flutter/material.dart';

class LoadingOverlay {
  static OverlayEntry? _overlayEntry;

  static void show(BuildContext context) {
    _overlayEntry = OverlayEntry(builder: (BuildContext context) {
      return Stack(
        children: [
          // Content of the screen
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                color: Colors.transparent,
              ),
            )
          ),
          // Loading indicator
          Positioned.fill(
            child: Container(
              color: Colors.black54,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(),
            )
          )
        ],
      );
    });

    Overlay.of(context)?.insert(_overlayEntry!);
  }

  static void hide() {
    _overlayEntry?.remove();
  }
}