import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference usernames = FirebaseFirestore.instance
    .collection("usernames");

Future<void> addUsername(String uid, String username) async {
  try {
    await usernames.doc(username).set({"uid": uid});
  } catch (e) {
    print("Error adding username: $e");
  }
}

Future<void> changeUsername(String currentUsername, String newUsername) async {
  try {
    final currentDocument = await usernames.doc(currentUsername).get();

    if (currentDocument.exists) {
      // Retrieve the data from the current document
      final userData = currentDocument.data();

      // Create a new document with the new username
      await usernames.doc(newUsername).set(userData!);

      // Delete the current document
      await usernames.doc(currentUsername).delete();
    }
    else {
      // Handle the case when the current username doesn't exist
      print("The current username does not exist");
    }
  } catch (e) {
    print("Error changing username: $e");
  }
}

Future<bool> usernameAvailable(String username) async {
  try {
    final QuerySnapshot snapshot =
      await usernames.where(FieldPath.documentId, isEqualTo: username).get();
    return snapshot.docs.isEmpty;
  } catch (e) {
    print("Error checking username availability: $e");
    return false;
  }
}

Future<String?> getUsername(String uid) async {
  try {
    final QuerySnapshot snapshot = await usernames
      .where("uid", isEqualTo: uid).limit(1).get();

    if (snapshot.size > 0) {
      final DocumentSnapshot document = snapshot.docs[0];
      return document.id;
    }
  } catch (e) {
    print("Error retrieving username: $e");
  }

  return null;
}