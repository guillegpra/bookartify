import 'package:cloud_firestore/cloud_firestore.dart';

final CollectionReference userGoodreadsUrls =
    FirebaseFirestore.instance.collection("user_goodreads_links");

Future<void> addUserGoodreadsUrl(String uid, String goodreadsUrl) async {
  try {
    await userGoodreadsUrls.doc(uid).set({"goodreadsUrl": goodreadsUrl});
  } catch (e) {
    print("Error adding user Goodreads URL: $e");
  }
}

Future<void> changeUserGoodreadsUrl(String uid, String newGoodreadsUrl) async {
  try {
    await userGoodreadsUrls.doc(uid).update({"goodreadsUrl": newGoodreadsUrl});
  } catch (e) {
    print("Error changing user Goodreads URL: $e");
  }
}

Future<String?> getUserGoodreadsUrl(String uid) async {
  try {
    final DocumentSnapshot snapshot = await userGoodreadsUrls.doc(uid).get();
    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>?;
      return data?['goodreadsUrl'] as String?;
    }
  } catch (e) {
    print("Error retrieving user Goodreads URL: $e");
  }
  return null;
}
