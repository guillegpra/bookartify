import 'dart:io';

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

  /**
   * Obtain image from given the imageName
   */
  Future<String> downloadUrl(String imageName) async {
    String downloadUrl = await storage.ref("test/$imageName").getDownloadURL();

    return downloadUrl;
  }
}