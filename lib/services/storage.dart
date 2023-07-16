import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> uploadFile(String filePath, String fileName) async {
    File file = File(filePath);

    try {
      await storage.ref("test/$fileName").putFile(file);
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future<ListResult> listFiles() async {
    ListResult result = await storage.ref("test").listAll();

    result.items.forEach((Reference ref) {
      print("Found file: $ref");
    });

    return result;
  }

  Future<ListResult> listArtByUser(String uid) async {
    ListResult result = await storage.ref("$uid/art").listAll();

    return result;
  }

  Future<ListResult> listCoversByUser(String uid) async {
    ListResult result = await storage.ref("$uid/cover").listAll();

    return result;
  }

  /// Obtain image from given the imageName
  Future<String> downloadUrl(String imageName) async {
    String downloadUrl = await storage.ref("test/$imageName").getDownloadURL();

    return downloadUrl;
  }

}

class TitlesStorage {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<String>> getArtArray(String uid) async {
    try {
      DocumentSnapshot snapshot = await firestore
          .collection('posts')
          .doc(uid)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

        if (data != null) {
          // Access the 'art' array field
          List<dynamic>? artArray = data['art'];

          if (artArray != null) {
            return List<String>.from(artArray);
          }
        }
      }
    } catch (e) {
      print('Error retrieving art array from Firestore: $e');
    }

    return []; // Return an empty array if the field or document doesn't exist
  }

  Future<List<dynamic>> getCoversArray(String uid) async {
    try {
      DocumentSnapshot snapshot = await firestore
          .collection('posts')
          .doc(uid)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

        if (data != null) {
          // Access the 'art' array field
          List<dynamic>? coversArray = data['cover'];

          if (coversArray != null) {
            return List<dynamic>.from(coversArray);
          }
        }
      }
    } catch (e) {
      print('Error retrieving art array from Firestore: $e');
    }

    return []; // Return an empty array if the field or document doesn't exist
  }
}