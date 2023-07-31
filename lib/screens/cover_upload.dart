import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:bookartify/widgets/upload_book_selection.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

class CoverUploadPage extends StatefulWidget {
  @override
  _CoverUploadPageState createState() => _CoverUploadPageState();
}

class _CoverUploadPageState extends State<CoverUploadPage> {
  late ImagePicker _imagePicker;
  String? _originalImagePath;
  Map<String, XFile?> coverImages = {
    'Front': null,
  };
  Map<String, String?> _selectedImagePaths = {
    'Front': null,
  };

  final ButtonStyle customButtonStyle = ButtonStyle(
    backgroundColor:
        MaterialStateProperty.all<Color>(const Color.fromARGB(255, 48, 80, 72)),
    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
  );

  late CropAspectRatio _cropAspectRatio;
  late CropStyle _cropStyle;
  String? selectedBookTitle;
  String? selectedBookAuthor;
  String? selectedBookId;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
    _cropAspectRatio = CropAspectRatio(ratioX: 1.6, ratioY: 2.56);
    _cropStyle = CropStyle.rectangle;
  }

  Future<void> _selectAndCropImage(String coverType) async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        coverImages[coverType] = pickedFile;
        _originalImagePath = pickedFile.path; // Store the original image path
        _selectedImagePaths[coverType] = null; // Clear the cropped image path
      });
      await _cropAndResizeImage(coverType);
    }
  }

  Future<void> _cropAndResizeImage(String coverType) async {
    final sourcePath = _originalImagePath; // Use the original image path
    if (sourcePath != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: sourcePath,
        aspectRatio: _cropAspectRatio,
        cropStyle: _cropStyle,
        compressQuality: 100,
        compressFormat: ImageCompressFormat.png,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Color(0xFFBFA054),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
            presentStyle: CropperPresentStyle.dialog,
            boundary: const CroppieBoundary(
              width: 520,
              height: 520,
            ),
            viewPort: const CroppieViewPort(
              width: 480,
              height: 480,
              type: 'circle',
            ),
            enableExif: true,
            enableZoom: true,
            showZoomer: true,
          ),
        ],
      );

      if (croppedFile != null) {
        setState(() {
          _selectedImagePaths[coverType] = croppedFile.path;
        });
      }
    }
  }

  Future<void> _uploadArt() async {
    // Check if all the required data is provided
    if (_selectedImagePaths['Front'] != null &&
        _titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        selectedBookId != null) {
      // Implement art upload and details saving logic to your database
      // You can access the selected image paths using _selectedImagePaths
      // You can access the entered details using the TextEditingController values
      // Handle the upload process and display a confirmation to the user

      // After the upload is complete, navigate to a confirmation page or another screen
      // You can pass any necessary data to the next screen

      // For example:
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ArtConfirmationPage(
            selectedImagePaths: _selectedImagePaths,
            title: _titleController.text,
            description: _descriptionController.text,
            selectedBookId: selectedBookId,
            selectedBookTitle: selectedBookTitle,
            selectedBookAuthor: selectedBookAuthor,
          ),
        ),
      );
    } else {
      // If any required data is missing, show an error dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill in all required fields.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfffbf8f2),
        centerTitle: true,
        title: Text(
          'Upload Your Cover',
          style: GoogleFonts.dmSerifDisplay(
            fontWeight: FontWeight.bold,
            color: Color(0xff2f2f2f),
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 16),
              GestureDetector(
                onTap: () => _cropAndResizeImage('Front'),
                child: Container(
                  alignment: Alignment.center,
                  child: _selectedImagePaths['Front'] != null
                      ? Stack(
                          children: [
                            Image.file(
                              File(_selectedImagePaths['Front']!),
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedImagePaths['Front'] =
                                        null; // Remove the selected cover
                                  });
                                },
                                child: Icon(
                                  Icons.close,
                                  color: Color.fromARGB(255, 255, 153, 0),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Image.asset(
                          'images/upload-images-placeholder.png',
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                child: Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: () => _selectAndCropImage('Front'),
                    style: customButtonStyle,
                    child: Text(
                      "Select cover from gallery",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Fill Cover Details',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                maxLength: 30, // Set maximum character limit to 30
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                maxLength: 100, // Set maximum character limit to 100
              ),
              SizedBox(height: 10),
              Text(
                'Select a Book',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  final selectedBook =
                      await Navigator.push<Map<String, dynamic>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchScreen(),
                    ),
                  );

                  if (selectedBook != null) {
                    setState(() {
                      selectedBookId = selectedBook['id'];
                      selectedBookTitle = selectedBook['title'];
                      selectedBookAuthor = selectedBook['author'];
                    });
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xff2f2f2f),
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.book),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          selectedBookTitle ?? 'Select a Book',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          final selectedBook =
                              await Navigator.push<Map<String, dynamic>>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchScreen(),
                            ),
                          );

                          if (selectedBook != null) {
                            setState(() {
                              selectedBookId = selectedBook['id'];
                              selectedBookTitle = selectedBook['title'];
                              selectedBookAuthor = selectedBook['author'];
                            });
                          }
                        },
                        icon: Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                child: Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: _uploadArt,
                    style: customButtonStyle,
                    child: Text(
                      "Publish Cover",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ArtConfirmationPage extends StatelessWidget {
  final Map<String, String?> selectedImagePaths;
  final String title;
  final String description;
  final String? selectedBookId;
  final String? selectedBookTitle;
  final String? selectedBookAuthor;

  ArtConfirmationPage({
    required this.selectedImagePaths,
    required this.title,
    required this.description,
    required this.selectedBookId,
    required this.selectedBookTitle,
    required this.selectedBookAuthor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Art Confirmation'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Book Cover',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Container(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: selectedImagePaths.length,
                  itemBuilder: (context, index) {
                    var entry = selectedImagePaths.entries.elementAt(index);
                    return Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Container(
                        width: 200,
                        child: entry.value != null
                            ? Image.file(
                                File(entry.value!),
                                fit: BoxFit.cover,
                              )
                            : Container(), // returns an empty Container when path is null
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Art Details:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text('Title: $title'),
              Text('Description: $description'),
              SizedBox(height: 16),
              Text(
                'Selected Book:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text('Title: ${selectedBookTitle ?? "N/A"}'),
              Text('Author: ${selectedBookAuthor ?? "N/A"}'),
            ],
          ),
        ),
      ),
    );
  }
}
