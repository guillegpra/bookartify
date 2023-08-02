import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bookartify/services/usernames_db.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:bookartify/widgets/upload_book_selection.dart';
import 'package:bookartify/services/database_api.dart';
import 'package:bookartify/screens/art_solo.dart';
import 'package:bookartify/models/book_search.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

class CoverUploadPage extends StatefulWidget {
  @override
  _CoverUploadPageState createState() => _CoverUploadPageState();
}

class _CoverUploadPageState extends State<CoverUploadPage> {
  bool _isUploading = false;
  late ImagePicker _imagePicker;
  String? _selectedImagePath;
  late CropStyle _cropStyle;
  late CropAspectRatio _cropAspectRatio;
  Book? selectedBook; // Declare selectedBook here
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
    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(42),
      ),
    ),
    minimumSize: MaterialStateProperty.all<Size>(Size(200, 50)),
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

  Future<Map<String, dynamic>> _getMostRecentCoverPost(String userId) async {
    try {
      // Fetch art posts from the database and sort them by the 'date_upload' field in descending order
      List<dynamic> coversPosts = await getCoversByUser(userId);
      coversPosts.sort((a, b) => b['date_upload'].compareTo(a['date_upload']));

      // Check if there are any art posts
      if (coversPosts.isNotEmpty) {
        // Get the most recent art post
        Map<String, dynamic> mostRecentPost = coversPosts.first;

        // Fetch the username of the poster
        String? username =
            await getUsername(mostRecentPost['user_id'].toString());

        // Add the username to the map and return it
        mostRecentPost['username'] = username ?? 'Unknown Artist';
        return mostRecentPost;
      } else {
        // If no art posts found, return an empty map
        return {};
      }
    } catch (e) {
      print('Error fetching most recent art post: $e');
      return {};
    }
  }

  // Function to show error dialog
  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
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

  Future<void> _uploadCover() async {
    if (_isUploading) return; // Prevent multiple clicks while uploading

    setState(() {
      _isUploading = true; // Start the upload process
    });

    if (_selectedImagePath != null) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Upload art image to Firebase Storage with type "art"
        String? imageUrl = await _uploadToFirebaseStorage(user.uid, 'covers');
        if (imageUrl != null) {
          // Image upload successful, now store data in the database
          try {
            await uploadCover(
              user.uid,
              _titleController.text,
              _descriptionController.text,
              selectedBookId ??
                  '', // Use selectedBookId if not null, otherwise use empty string
              imageUrl,
            );

            // Fetch the newly uploaded art post from the database
            List<dynamic> coversPosts = await getCoversByUser(user.uid);
            if (coversPosts.isNotEmpty) {
              // Get the index of the latest art post
              // Fetch the newly uploaded art post from the database
              Map<String, dynamic>? latestCoverPost =
                  await _getMostRecentCoverPost(user.uid);

              // Artwork uploaded successfully, show the "Post Published" page
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ArtSoloScreen(
                    type: 'cover', // Set the correct type (e.g., 'art')
                    post:
                        latestCoverPost, // Pass the data of the latest published art post
                    book: selectedBook ??
                        Book(
                          id: '',
                          title: 'No Book Selected',
                          author: '',
                          thumbnailUrl:
                              '', // Provide any default thumbnail URL if needed
                          publishedDate: '',
                          pageCount: 0,
                          description: '',
                        ),
                  ),
                ),
              );
              setState(() {
                _isUploading = false; // Reset the upload state
              });
            } else {
              // No art posts found, show an error dialog
              _showErrorDialog('Failed to load published cover post.');
            }
          } catch (e) {
            // Error while uploading to database
            print('Error uploading cover to database: $e');
            _showErrorDialog('Please fill all details and select a book');
          }
        } else {
          // Image upload failed, show error dialog
          _showErrorDialog('Failed to upload image. Please try again.');
        }
      }
    } else {
      _showErrorDialog('You must select an image.');
    }

    setState(() {
      _isUploading = false; // Reset the upload state
    });
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
                maxLength: 80, // Set maximum character limit to 80
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
                  final book = await Navigator.push<Map<String, dynamic>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SearchScreen(),
                    ),
                  );
                  if (book != null) {
                    setState(() {
                      selectedBook = Book(
                        id: book['id'],
                        title: book['title'],
                        author: book['author'],
                        thumbnailUrl: book['thumbnailUrl'],
                        publishedDate: book['publishedDate'],
                        pageCount: book['pageCount'],
                        description: book['description'],
                      );
                      selectedBookTitle = book['title'];
                      selectedBookAuthor = book['author'];
                      selectedBookId = book['id'];
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
                    onPressed: _isUploading ? null : _uploadCover,
                    // Disable the button if upload is in progress
                    style: customButtonStyle,
                    child: _isUploading
                        ? CircularProgressIndicator() // Show progress indicator
                        : Text(
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
