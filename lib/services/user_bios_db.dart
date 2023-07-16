import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference userBio =
    FirebaseFirestore.instance.collection("user_bios");

Future<void> addUserBio(String uid, String bio) async {
  try {
    await userBio.doc(uid).set({"bio": bio});
  } catch (e) {
    print("Error adding user bio: $e");
  }
}

Future<void> changeUserBio(String uid, String newBio) async {
  try {
    await userBio.doc(uid).update({"bio": newBio});
  } catch (e) {
    print("Error changing user bio: $e");
  }
}

Future<String?> getUserBio(String uid) async {
  try {
    final DocumentSnapshot snapshot = await userBio.doc(uid).get();
    if (snapshot.exists) {
      final bio = snapshot.data()
          as Map<String, dynamic>?; // Cast to Map<String, dynamic>
      return bio?['bio'] as String?;
    }
  } catch (e) {
    print("Error retrieving user bio: $e");
  }

  return null;
}
