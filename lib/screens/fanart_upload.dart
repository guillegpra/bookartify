import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bookartify/services/usernames_db.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:bookartify/widgets/upload_book_selection.dart';
import 'package:bookartify/services/database_api.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

class ArtUploadPage extends StatefulWidget {
  @override
  _ArtUploadPageState createState() => _ArtUploadPageState();
}

class _ArtUploadPageState extends State<ArtUploadPage> {
  late ImagePicker _imagePicker;
  String? _selectedImagePath;
  late CropStyle _cropStyle;
  late CropAspectRatio _cropAspectRatio;
  String? selectedBookTitle;
  String? selectedBookAuthor;
  String? selectedBookId;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  String _currentUsername = '';

  final ButtonStyle customButtonStyle = ButtonStyle(
    backgroundColor:
        MaterialStateProperty.all<Color>(const Color.fromARGB(255, 48, 80, 72)),
    foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
  );

  @override
  void initState() {
    super.initState();
    _imagePicker = ImagePicker();
    _cropAspectRatio = CropAspectRatio(ratioX: 16, ratioY: 9);
    _cropStyle = CropStyle.rectangle;
    _fetchCurrentUsername();
  }

  Future<void> _fetchCurrentUsername() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final String? username = await getUsername(user.uid);
      setState(() {
        _currentUsername = username ?? '';
        _usernameController.text = _currentUsername;
      });
    }
  }

  // Function to handle the upload process to Firebase Storage
  Future<String?> _uploadToFirebaseStorage(String userId, String type) async {
    if (_selectedImagePath == null) return null;

    try {
      final filePath =
          'users_posts/$userId/$type/${DateTime.now().millisecondsSinceEpoch}.png';
      final firebase_storage.Reference storageReference =
          firebase_storage.FirebaseStorage.instance.ref(filePath);

      final metadata = firebase_storage.SettableMetadata(
        contentType:
            'image/png', // Change the content type based on your image format
      );

      await storageReference.putFile(File(_selectedImagePath!), metadata);

      final downloadURL = await storageReference.getDownloadURL();
      return downloadURL;
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      return null;
    }
  }

  Future<void> _selectImage() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImagePath = pickedFile.path;
      });
      await _cropImage();
    }
  }

  Future<void> _cropImage() async {
    final sourcePath = _selectedImagePath;
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: sourcePath!,
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
        _selectedImagePath = croppedFile.path;
      });
    }
  }

  Future<void> _uploadArt() async {
    if (_selectedImagePath != null) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Upload art image to Firebase Storage with type "art"
        String? imageUrl = await _uploadToFirebaseStorage(user.uid, 'art');
        if (imageUrl != null) {
          // Image upload successful, now store data in the database
          try {
            await uploadArt(
              user.uid,
              _titleController.text,
              _descriptionController.text,
              selectedBookId ??
                  '', // Use selectedBookId if not null, otherwise use empty string
              imageUrl,
            );

            // Artwork uploaded successfully, show the "Post Published" page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PostPublishedPage(),
              ),
            );
          } catch (e) {
            // Error while uploading to database
            print('Error uploading art to database: $e');
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text('Failed to upload artwork to the database.'),
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
        } else {
          // Image upload failed, show error dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Failed to upload image. Please try again.'),
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
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('You must select an image.'),
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
          'Upload Your Art Work',
          style: GoogleFonts.dmSerifDisplay(
            fontWeight: FontWeight.bold,
            color: Color(0xff2f2f2f),
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Container(
                alignment: Alignment.center,
                child: _selectedImagePath == null
                    ? Center(
                        child: Image.asset(
                          'images/upload-images-placeholder.png', // replace with your placeholder image path
                          fit: BoxFit.cover,
                        ),
                      )
                    : Stack(
                        children: [
                          GestureDetector(
                            onTap: _cropImage,
                            child: Image.file(
                              File(_selectedImagePath!),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedImagePath = null;
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
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                child: Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: _selectImage,
                    style: customButtonStyle,
                    child: Text(
                      "Select art from gallery",
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
                'Fill Art Details',
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
                maxLength: 30,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLength: 80,
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
                  final selectedBook =
                      await Navigator.push<Map<String, dynamic>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchScreen(),
                    ),
                  );

                  if (selectedBook != null) {
                    setState(() {
                      selectedBookTitle = selectedBook['title'];
                      selectedBookAuthor = selectedBook['author'];
                      selectedBookId = selectedBook[
                          'id']; // Add this line to store the book ID
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
                      "Publish Art",
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

class PostPublishedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Post Was Published'),
        backgroundColor: Color(0xfffbf8f2),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Congratulations! Your art work has been published.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
