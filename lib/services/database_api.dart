import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = "https://bookartify.scss.tcd.ie";

/* ------------------ Art ------------------ */
Future<List<dynamic>> getArtByUser(String userId) async {
  final http.Response response =
      await http.get(Uri.parse("$baseUrl/user/$userId/art"));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print(data.toString());
    return data as List<dynamic>;
  } else {
    throw Exception("Failed to load art by user with id: $userId");
  }
}

Future<List<dynamic>> getArtByBook(int bookId) async {
  final http.Response response =
      await http.get(Uri.parse("$baseUrl/book/$bookId/art"));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data as List<dynamic>;
  } else {
    throw Exception("Failed to load art for book with id: $bookId");
  }
}

Future<int> getArtCountByUser(String userId) async {
  final http.Response response =
      await http.get(Uri.parse("$baseUrl/user/$userId/art/count"));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data["count"];
  } else {
    throw Exception("Failed to load artwork count");
  }
}

Future<void> uploadArt(
    String userId, String title, String description, String bookId, String imageUrl) async {
  final url = Uri.parse("$baseUrl/art/upload");

  final body = jsonEncode({
    "userId": userId,
    "title": title,
    "bookId": bookId,
    "imageUrl": imageUrl,
  });

  final headers = {
    "Content-Type": "application/json",
  };

  final http.Response response =
      await http.post(url, headers: headers, body: body);

  if (response.statusCode == 201) {
    print("Artwork uploaded successfully");
  } else {
    throw Exception("Failed to upload artwork to the server");
  }
}

/* ------------------ Covers ------------------ */
Future<List<dynamic>> getCoversByUser(String userId) async {
  final http.Response response =
      await http.get(Uri.parse("$baseUrl/user/$userId/covers"));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data as List<dynamic>;
  } else {
    throw Exception("Failed to load covers by user with id: $userId");
  }
}

Future<List<dynamic>> getCoversByBook(int bookId) async {
  final http.Response response =
      await http.get(Uri.parse("$baseUrl/book/$bookId/covers"));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data as List<dynamic>;
  } else {
    throw Exception("Failed to load covers for book with id: $bookId");
  }
}

Future<int> getCoversCountByUser(String userId) async {
  final http.Response response =
      await http.get(Uri.parse("$baseUrl/user/$userId/covers/count"));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data["count"];
  } else {
    throw Exception("Failed to load artwork count");
  }
}

Future<void> uploadCover(
    String userId, String title, String description, String bookId, String imageUrl) async {
  final url = Uri.parse("$baseUrl/covers/upload");

  final headers = {
    "Content-Type": "application/json",
  };

  final body = jsonEncode({
    "userId": userId,
    "title": title,
    "bookId": bookId,
    "imageUrl": imageUrl,
  });

  final http.Response response =
      await http.post(url, headers: headers, body: body);

  if (response.statusCode == 201) {
    print("Cover uploaded successfully");
  } else {
    throw Exception("Failed to upload cover to the server");
  }
}

/* ------------------ Follow ------------------ */
Future<void> followUser(String userId, String followingId) async {
  final url = Uri.parse("$baseUrl/follow_user");

  final headers = {
    "Content-Type": "application/json",
  };

  final body = jsonEncode({
    "userId": userId,
    "followingId": followingId,
  });

  final http.Response response =
      await http.post(url, headers: headers, body: body);

  if (response.statusCode == 201) {
    print("User followed successfully");
  } else {
    throw Exception("Failed to follow user");
  }
}

Future<void> unfollowUser(String userId, String followingId) async {
  final url = Uri.parse("$baseUrl/unfollow_user/$userId/$followingId");

  final http.Response response = await http.delete(url);

  if (response.statusCode == 201) {
    print("User unfollowed successfully");
  } else {
    throw Exception("Failed to unfollow user");
  }
}

Future<void> followBook(String userId, String followingId) async {
  final url = Uri.parse("$baseUrl/follow_book");

  final headers = {
    "Content-Type": "application/json",
  };

  final body = jsonEncode({
    "userId": userId,
    "followingId": followingId,
  });

  final http.Response response =
      await http.post(url, headers: headers, body: body);

  if (response.statusCode == 201) {
    print("Book followed successfully");
  } else {
    throw Exception("Failed to follow book");
  }
}

Future<void> unfollowBook(String userId, String followingId) async {
  final url = Uri.parse("$baseUrl/unfollow_book/$userId/$followingId");

  final http.Response response = await http.delete(url);

  if (response.statusCode == 201) {
    print("User unfollowed successfully");
  } else {
    throw Exception("Failed to unfollow user");
  }
}

Future<int> getFollowersCountByUser(String userId) async {
  final http.Response response =
      await http.get(Uri.parse("$baseUrl/user/$userId/followers/count"));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data["followers"];
  } else {
    throw Exception("Failed to load followers count");
  }
}

Future<int> getFollowingCountByUser(String userId) async {
  final http.Response response =
      await http.get(Uri.parse("$baseUrl/user/$userId/following/count"));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data["following"];
  } else {
    throw Exception("Failed to load following count");
  }
}

Future<bool> isFollowingUser(String userId, String followingId) async {
  final http.Response response = await
    http.get(Uri.parse("$baseUrl/check_follow/user?user_id=$userId&following_id=$followingId"));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data["isFollowing"];
  } else {
    throw Exception("Failed to check follow status");
  }
}

Future<bool> isFollowingBook(String userId, String followingId) async {
  final http.Response response = await
    http.get(Uri.parse("$baseUrl/check_follow/book?user_id=$userId&following_id=$followingId"));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data["isFollowing"];
  } else {
    throw Exception("Failed to check follow status");
  }
}

/* ------------------ Likes ------------------ */
Future<void> likeArt(String userId, String artId) async {
  final url = Uri.parse("$baseUrl/like_art");

  final headers = {
    "Content-Type": "application/json",
  };

  final body = jsonEncode({
    "userId": userId,
    "artId": artId,
  });

  final http.Response response =
  await http.post(url, headers: headers, body: body);

  if (response.statusCode == 201) {
    print("Artwork liked successfully");
  } else {
    throw Exception("Failed to like artwork");
  }
}

Future<void> likeCover(String userId, String coverId) async {
  final url = Uri.parse("$baseUrl/like_cover");

  final headers = {
    "Content-Type": "application/json",
  };

  final body = jsonEncode({
    "userId": userId,
    "coverId": coverId,
  });

  final http.Response response =
    await http.post(url, headers: headers, body: body);

  if (response.statusCode == 201) {
    print("Cover liked successfully");
  } else {
    throw Exception("Failed to like cover");
  }
}

Future<void> unlikeArt(String userId, String artId) async {
  final url = Uri.parse("$baseUrl/unlike_art/$userId/$artId");

  final http.Response response = await http.delete(url);

  if (response.statusCode == 201) {
    print("Artwork unliked successfully");
  } else {
    throw Exception("Failed to unlike artwork");
  }
}

Future<void> unlikeCover(String userId, String coverId) async {
  final url = Uri.parse("$baseUrl/unlike_cover/$userId/$coverId");

  final http.Response response = await http.delete(url);

  if (response.statusCode == 201) {
    print("Cover unliked successfully");
  } else {
    throw Exception("Failed to unlike cover");
  }
}

/* ------------------ Bookmarks ------------------ */
Future<void> bookmarkArt(String userId, String artId) async {
  final url = Uri.parse("$baseUrl/bookmark_art");

  final headers = {
    "Content-Type": "application/json",
  };

  final body = jsonEncode({
    "userId": userId,
    "artId": artId,
  });

  final http.Response response =
    await http.post(url, headers: headers, body: body);

  if (response.statusCode == 201) {
    print("Artwork liked successfully");
  } else {
    throw Exception("Failed to like artwork");
  }
}

Future<void> bookmarkCover(String userId, String coverId) async {
  final url = Uri.parse("$baseUrl/bookmark_cover");

  final headers = {
    "Content-Type": "application/json",
  };

  final body = jsonEncode({
    "userId": userId,
    "coverId": coverId,
  });

  final http.Response response =
    await http.post(url, headers: headers, body: body);

  if (response.statusCode == 201) {
    print("Cover liked successfully");
  } else {
    throw Exception("Failed to like cover");
  }
}

Future<void> unbookmarkArt(String userId, String artId) async {
  final url = Uri.parse("$baseUrl/unbookmark_art/$userId/$artId");

  final http.Response response = await http.delete(url);

  if (response.statusCode == 201) {
    print("Removed bookmark from artwork successfully");
  } else {
    throw Exception("Failed to remove bookmark from artwork");
  }
}

Future<void> unbookmarkCover(String userId, String coverId) async {
  final url = Uri.parse("$baseUrl/unbookmark_cover/$userId/$coverId");

  final http.Response response = await http.delete(url);

  if (response.statusCode == 201) {
    print("Removed bookmark from cover successfully");
  } else {
    throw Exception("Failed to remove bookmark from cover");
  }
}


Future<List<dynamic>> getBookmarksByUser(String userId) async {
  final http.Response response =
      await http.get(Uri.parse("$baseUrl/user/$userId/bookmarks"));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data as List<dynamic>;
  } else {
    throw Exception("Failed to load bookmarks by user with id: $userId");
  }
}

/* ------------------ For You ------------------ */
Future<List<dynamic>> getForYouByUser(String userId) async {
  final http.Response response =
  await http.get(Uri.parse("$baseUrl/user/$userId/home"));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data as List<dynamic>;
  } else {
    throw Exception("Failed to load bookmarks by user with id: $userId");
  }
}
