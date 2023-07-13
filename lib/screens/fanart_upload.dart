import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:bookartify/models/book_search.dart';
import 'package:bookartify/widgets/upload_book_selection.dart';
import 'dart:io';

class ArtUploadPage extends StatefulWidget {
  @override
  _ArtUploadPageState createState() => _ArtUploadPageState();
}

class _ArtUploadPageState extends State<ArtUploadPage> {
  late ImagePicker _imagePicker;
  List<XFile> _pickedFiles = [];
  List<String> _selectedImagePaths = [];
  late CropAspectRatio _cropAspectRatio;
  late CropStyle _cropStyle;
  String? selectedImagePath;
  String? selectedBookTitle;
  String? selectedBookAuthor;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _artistController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
    _cropAspectRatio = CropAspectRatio(ratioX: 1, ratioY: 1);
    _cropStyle = CropStyle.rectangle;
  }

  Future<void> _selectImages() async {
    final pickedFiles = await _imagePicker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _pickedFiles = pickedFiles;
        _selectedImagePaths = pickedFiles.map((file) => file.path).toList();
      });
    }
  }

  Future<void> _cropImage(int index) async {
    final sourcePath = _selectedImagePaths[index];
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: sourcePath,
      aspectRatio: _cropAspectRatio,
      cropStyle: _cropStyle,
      compressQuality: 100,
      maxHeight: 512,
      maxWidth: 512,
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
        _selectedImagePaths[index] = croppedFile.path;
      });
    }
  }

  Future<void> _uploadArt() async {
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
          artist: _artistController.text,
          description: _descriptionController.text,
          selectedBookTitle: selectedBookTitle,
          selectedBookAuthor: selectedBookAuthor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfffbf8f2),
        centerTitle: true, // Change this line
        title: Text('Upload Your Art Work'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Container(
                height: 150,
                child: _selectedImagePaths.isEmpty
                    ? Center(
                        child: Image.asset(
                          'images/upload-images-placeholder.png', // replace with your placeholder image path
                          fit: BoxFit.cover,
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _selectedImagePaths.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.only(right: 8.0),
                            child: Container(
                              child: Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () => _cropImage(index),
                                    child: Image.file(
                                      File(_selectedImagePaths[index]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedImagePaths.removeAt(index);
                                        });
                                      },
                                      child: Icon(
                                        Icons.close,
                                        color: Color.fromARGB(255, 255, 153, 0),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                child: Align(
                  alignment: Alignment.center,
                  child: MaterialButton(
                    onPressed: _selectImages,
                    color: Color(0xff2f2f2f),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(color: Color(0x85808080), width: 1),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                    child: Text(
                      "Select art from gallery",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    textColor: Color(0xffe3d4b5),
                    height: 40,
                    minWidth: 140,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Enter Art Details',
                style: TextStyle(
                  fontSize: 18,
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
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _artistController,
                decoration: InputDecoration(
                  labelText: 'Artist',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 32),
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
                  final selectedBook = await Navigator.push<Book?>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchScreen(),
                    ),
                  );

                  if (selectedBook != null) {
                    setState(() {
                      selectedBookTitle = selectedBook.title;
                      selectedBookAuthor = selectedBook.author;
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
                          final selectedBook = await Navigator.push<Book?>(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchScreen(),
                            ),
                          );

                          if (selectedBook != null) {
                            setState(() {
                              selectedBookTitle = selectedBook.title;
                              selectedBookAuthor = selectedBook.author;
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
                  child: MaterialButton(
                    onPressed: _uploadArt,
                    color: Color(0xff2f2f2f),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(color: Color(0x85808080), width: 1),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                    child: Text(
                      "Upload Art",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    textColor: Color(0xffe3d4b5),
                    height: 40,
                    minWidth: 140,
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
  final List<String> selectedImagePaths;
  final String title;
  final String artist;
  final String description;
  final String? selectedBookTitle;
  final String? selectedBookAuthor;

  ArtConfirmationPage({
    required this.selectedImagePaths,
    required this.title,
    required this.artist,
    required this.description,
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
                'Selected Images:',
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
                    return Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Container(
                        width: 200,
                        child: Image.file(
                          File(selectedImagePaths[index]),
                          fit: BoxFit.cover,
                        ),
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
              Text('Artist: $artist'),
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
