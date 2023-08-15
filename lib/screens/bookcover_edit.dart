import 'dart:async';
import 'dart:convert'; // Import dart:convert library
import 'package:flutter/material.dart';
import 'package:flutter_unity_widget/flutter_unity_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bookartify/screens/ARcover_screen.dart';

class BookCover extends StatefulWidget {
  const BookCover({Key? key}) : super(key: key);

  @override
  State<BookCover> createState() => _BookCoverState();
}

class _BookCoverState extends State<BookCover> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  UnityWidgetController? _unityWidgetController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(70, 192, 162, 73),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Cover",
          style: GoogleFonts.dmSerifDisplay(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: WillPopScope(
          onWillPop: () async {
            // Pop the category page if Android back button is pressed.
            return true;
          },
          child: Container(
            color: const Color.fromARGB(255, 255, 255, 255),
            child: UnityWidget(
              onUnityCreated: onUnityCreated,
              onUnityMessage: onUnityMessage,
            ),
          ),
        ),
      ),
    );
  }

  // Callback that connects the created controller to the unity controller
  void onUnityCreated(controller) {
    _unityWidgetController = controller;
  }

  void onUnityMessage(message) {
    if (message.toString() == "buttonClicked") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ARCover()),
      );
    } else if (message.toString().startsWith("openGallery")) {
      // Call the image gallery function here
      openGallery().then((imageData) {
        if (imageData != null) {
          // Send the image data back to Unity
          _unityWidgetController?.postMessage(
            'Canvas', // Replace with the name of your GameObject
            'OnImageSelected' + message.toString().substring(11), // Append the button number to the method name
            imageData,
          );
        }
      });
    }
  }

  Future<String?> openGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Get the image data as bytes
      List<int> imageBytes = await pickedFile.readAsBytes();

      // Convert the image bytes to Base64 encoded string
      String imageData = base64Encode(imageBytes);

      // Return the image data
      return imageData;
    }

    return null;
  }
}
