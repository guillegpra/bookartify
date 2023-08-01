import 'package:bookartify/services/database_api.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bookartify/services/user_bios_db.dart';
import 'package:bookartify/services/usernames_db.dart';
import 'package:bookartify/services/user_profile_pics_db.dart';
import 'package:bookartify/services/user_goodreads_links_db.dart';
import 'package:bookartify/screens/profile_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  final String userId;

  const EditProfileScreen({super.key, required this.userId});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _goodreadsUrlController = TextEditingController();
  File? _selectedImage;
  String _currentBio = '';
  String _currentUsername = '';
  String? _currentProfilePicUrl;
  String _currentGoodreadsUrl = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    Map<String, dynamic> data = await getUserById(widget.userId);
    print(data.toString());
    setState(() {
      // username
      _currentUsername = data["username"] ?? '';
      _usernameController.text = _currentUsername;

      // bio
      _currentBio = data["bio"] ?? '';
      _bioController.text = _currentBio;

      // profile pic
      _currentProfilePicUrl = data["profile_pic_url"] ?? '';

      // goodreads url
      _currentGoodreadsUrl = data["goodreads_url"] ?? '';
      _goodreadsUrlController.text = _currentGoodreadsUrl;
    });
  }

  Future<void> _selectImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      final croppedImage = await ImageCropper().cropImage(
        sourcePath: pickedImage.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        cropStyle: CropStyle.circle,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: const Color(0xFFBFA054),
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Crop Image',
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
      if (croppedImage != null) {
        setState(() {
          _selectedImage = File(croppedImage.path);
        });
      }
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      final reference = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('user_profile_pics/${widget.userId}');
      final uploadTask = reference.putFile(image);
      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  // Future<void> _fetchCurrentBio() async {
  //   if (widget.currentUser != null) {
  //     final String? bio = await getUserBio(widget.currentUser!.uid);
  //     setState(() {
  //       _currentBio = bio ?? '';
  //       _bioController.text = _currentBio;
  //     });
  //   }
  // }
  //
  // Future<void> _fetchCurrentUsername() async {
  //   if (widget.currentUser != null) {
  //     final String? username = await getUsername(widget.currentUser!.uid);
  //     setState(() {
  //       _currentUsername = username ?? '';
  //       _usernameController.text = _currentUsername;
  //     });
  //   }
  // }
  //
  // Future<void> _fetchCurrentProfilePic() async {
  //   if (widget.currentUser != null) {
  //     final String? profilePicUrl =
  //         await getUserProfilePic(widget.currentUser!.uid);
  //     setState(() {
  //       _currentProfilePicUrl = profilePicUrl;
  //     });
  //   }
  // }
  //
  // Future<void> _fetchCurrentGoodreadsUrl() async {
  //   if (widget.currentUser != null) {
  //     final String? goodreadsUrl =
  //         await getUserGoodreadsUrl(widget.currentUser!.uid);
  //     setState(() {
  //       _currentGoodreadsUrl = goodreadsUrl ?? '';
  //       _goodreadsUrlController.text = _currentGoodreadsUrl;
  //     });
  //   }
  // }

  void _saveChanges() async {
    final String newBio = _bioController.text;
    final String newUsername = _usernameController.text;
    bool changesMade = false;

    try {
      // Update the bio
      if (newBio != _currentBio) {
        await updateBio(widget.userId, newBio);
        setState(() {
          _currentBio = newBio;
        });
        changesMade = true;
      }

      // Update the username
      if (newUsername != _currentUsername) {
        // final currentUsername = _currentUsername;
        // await changeUsername(currentUsername, newUsername);
        await updateUsername(widget.userId, newUsername);
        setState(() {
          _currentUsername = newUsername;
        });
        changesMade = true;
      }

      // Update the Goodreads URL
      if (_goodreadsUrlController.text != _currentGoodreadsUrl) {
        await updateGoodreadsUrl(widget.userId, _goodreadsUrlController.text);
        setState(() {
          _currentGoodreadsUrl = _goodreadsUrlController.text;
        });
        changesMade = true;
      }

      // Upload and update the profile picture
      if (_selectedImage != null) {
        final imageUrl = await _uploadImage(_selectedImage!);
        if (imageUrl != null) {
          await updateProfilePicUrl(widget.userId, imageUrl);
          changesMade = true;
        }
      }

      if (changesMade) {
        // Show a success message or navigate to another page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ProfileScreen(userId: widget.userId)),
        );
      } else {
        // No changes were made
        // navigate back
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error updating user profile: $e');
      // Show an error message
    }
  }

  @override
  void dispose() {
    _bioController.dispose();
    _usernameController.dispose();
    _goodreadsUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Edit Profile',
          style: GoogleFonts.dmSerifDisplay(
            fontWeight: FontWeight.bold,
            color: const Color(0xff2f2f2f),
            fontSize: 20,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saveChanges,
            child: Text(
              'Save',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.normal,
                color: const Color(0xff2f2f2f),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_selectedImage != null)
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xff2f2f2f),
                            width: 2.0, // Width of the border
                          ),
                        ),
                        child: ClipOval(
                          child: Image.file(
                            _selectedImage!,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    else if (_currentProfilePicUrl != null && _currentProfilePicUrl != "")
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xff2f2f2f),
                            width: 2.0, // Width of the border
                          ),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            _currentProfilePicUrl!,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    const SizedBox(height: 10),
                    MaterialButton(
                      onPressed: () => _selectImage(ImageSource.gallery),
                      color: const Color(0xff2f2f2f),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: const BorderSide(
                            color: Color(0x85808080), width: 1),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 25),
                      textColor: const Color(0xffe3d4b5),
                      height: 40,
                      minWidth: 140,
                      child: const Text(
                        "Change Picture",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(6.0, 0, 0, 0),
                child: Text(
                  'Username',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _usernameController,
                maxLength: 20,
                decoration: InputDecoration(
                  hintText: 'Enter your username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide:
                      const BorderSide(color: Color(0x85808080), width: 2.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.fromLTRB(6.0, 0, 0, 0),
                child: Text(
                  'Bio',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _bioController,
                maxLength: 40,
                decoration: InputDecoration(
                  hintText: 'Enter your bio',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide:
                        const BorderSide(color: Color(0x85808080), width: 2.0),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.fromLTRB(6.0, 0, 0, 0),
                child: Text(
                  'Goodreads Profile',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _goodreadsUrlController,
                decoration: InputDecoration(
                  hintText: 'Enter your Goodreads profile link',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide:
                        const BorderSide(color: Color(0x85808080), width: 2.0),
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
