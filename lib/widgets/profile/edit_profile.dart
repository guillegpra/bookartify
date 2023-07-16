import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bookartify/services/user_bios_db.dart';
import 'package:bookartify/services/usernames_db.dart';
import 'package:bookartify/services/user_profile_pics_db.dart';
import 'package:bookartify/screens/profile_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  final User? currentUser;

  const EditProfileScreen({required this.currentUser});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  File? _selectedImage; // Added variable to store the selected image file

  String _currentBio = '';
  String _currentUsername = ''; // Added variable for current username

  @override
  void initState() {
    super.initState();
    _fetchCurrentBio();
    _fetchCurrentUsername(); // Fetch the current username
  }

  Future<void> _selectImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      final reference = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('user_profile_pics/${widget.currentUser!.uid}');
      final uploadTask = reference.putFile(image);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  Future<void> _fetchCurrentBio() async {
    if (widget.currentUser != null) {
      final String? bio = await getUserBio(widget.currentUser!.uid);
      setState(() {
        _currentBio = bio ?? '';
        _bioController.text = _currentBio;
      });
    }
  }

  Future<void> _fetchCurrentUsername() async {
    if (widget.currentUser != null) {
      final String? username = await getUsername(widget.currentUser!.uid);
      setState(() {
        _currentUsername = username ?? '';
        _usernameController.text = _currentUsername;
      });
    }
  }

  void _saveChanges() async {
    final String newBio = _bioController.text;
    final String newUsername = _usernameController.text;

    if (widget.currentUser != null &&
        (newBio != _currentBio || newUsername != _currentUsername)) {
      try {
        // Update the bio
        if (newBio != _currentBio) {
          await addUserBio(widget.currentUser!.uid, newBio);
          setState(() {
            _currentBio = newBio;
          });
        }

        // Update the username
        if (newUsername != _currentUsername) {
          final currentUsername =
              _currentUsername; // Use _currentUsername instead of widget.currentUser!.displayName
          await changeUsername(currentUsername, newUsername);
          setState(() {
            _currentUsername = newUsername;
          });
        }

        // Upload and update the profile picture
        if (_selectedImage != null) {
          final imageUrl = await _uploadImage(_selectedImage!);
          if (imageUrl != null) {
            await addUserProfilePic(widget.currentUser!.uid, imageUrl);
          }
        }

        // Show a success message or navigate to another page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen()),
        );
      } catch (e) {
        print('Error updating user profile: $e');
        // Show an error message
      }
    } else {
      // No changes were made
      // Show a message or navigate back
    }
  }

  @override
  void dispose() {
    _bioController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: _saveChanges,
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bio',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            TextField(
              controller: _bioController,
              decoration: InputDecoration(
                hintText: 'Enter your bio',
              ),
            ),
            Text(
              'Username',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: 'Enter your username',
              ),
            ),
            ElevatedButton(
              onPressed: () => _selectImage(ImageSource.gallery),
              child: Text('Select Image'),
            ),
            SizedBox(height: 16.0),
            if (_selectedImage != null)
              Image.file(
                _selectedImage!,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
          ],
        ),
      ),
    );
  }
}
