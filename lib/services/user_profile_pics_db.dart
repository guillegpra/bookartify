import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference userProfilePics =
    FirebaseFirestore.instance.collection("user_profile_pics");

Future<void> addUserProfilePic(String uid, String imageUrl) async {
  try {
    await userProfilePics.doc(uid).set({"imageUrl": imageUrl});
  } catch (e) {
    print("Error adding user profile picture: $e");
  }
}

Future<void> changeUserProfilePic(String uid, String imageUrl) async {
  try {
    await userProfilePics.doc(uid).update({"imageUrl": imageUrl});
  } catch (e) {
    print("Error changing user profile picture: $e");
  }
}

Future<String?> getUserProfilePic(String uid) async {
  try {
    final DocumentSnapshot snapshot = await userProfilePics.doc(uid).get();
    if (snapshot.exists) {
      final profilePic = snapshot.data()
          as Map<String, dynamic>?; // Cast to Map<String, dynamic>
      return profilePic?['imageUrl'] as String?;
    }
  } catch (e) {
    print("Error retrieving user profile picture: $e");
  }

  return null;
}
