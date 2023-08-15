import 'dart:convert';
import 'package:http/http.dart' as http;

const String baseUrl = "https://bookartify.scss.tcd.ie";

/* ------------------ User ------------------ */
Future<void> addUser(String userId, String username) async {
  final url = Uri.parse("$baseUrl/user/add_user");

  final body = jsonEncode({
    "id": userId,
    "username": username,
  });

  final headers = {
    "Content-Type": "application/json",
  };

  final http.Response response =
      await http.post(url, headers: headers, body: body);

  if (response.statusCode == 201) {
    print("User created successfully");
  } else {
    throw Exception("Failed to create user in database");
  }
}

Future<Map<String, dynamic>> getUserById(String userId) async {
  final http.Response response =
      await http.get(Uri.parse("$baseUrl/user/$userId"));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print(data.toString());
    return data as Map<String, dynamic>;
  } else {
    throw Exception("Failed to get user data for id: $userId");
  }
}

Future<String> getUsernameById(String userId) async {
  final http.Response response =
      await http.get(Uri.parse("$baseUrl/user/$userId"));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    print("---------------- Username: ${data["username"].toString()}");
    return data["username"].toString();
  } else {
    throw Exception("Failed to get user data for id: $userId");
  }
}

Future<void> updateBio(String userId, String newBio) async {
  final url = Uri.parse("$baseUrl/user/$userId/update_bio");

  try {
    final http.Response response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "bio": newBio,
      }),
    );

    if (response.statusCode == 200) {
      print("Bio updated successfully");
    } else {
      print("Failed to update bio: ${response.reasonPhrase}");
    }
  } catch (e) {
    print("Error updating bio: $e");
  }
}

Future<void> updateUsername(String userId, String newUsername) async {
  final bool isAvailable = await isUsernameAvailable(newUsername);

  if (isAvailable) {
    final url = Uri.parse("$baseUrl/user/$userId/update_username");

    try {
      final http.Response response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "username": newUsername,
        }),
      );

      if (response.statusCode == 200) {
        print("Username updated successfully");
      } else {
        print("Failed to update username: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error updating username: $e");
    }
  } else {
    print("Username is not available");
  }
}

Future<bool> isUsernameAvailable(String username) async {
  final http.Response response =
      await http.get(Uri.parse("$baseUrl/check_username?username=$username"));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data["isAvailable"];
  } else {
    throw Exception("Failed to check username status");
  }
}

Future<void> updateProfilePicUrl(String userId, String profilePicUrl) async {
  final url = Uri.parse("$baseUrl/user/$userId/update_profile_pic");

  try {
    final http.Response response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "profilePicUrl": profilePicUrl,
      }),
    );

    if (response.statusCode == 200) {
      print("Bio updated successfully");
    } else {
      print("Failed to update profile pic: ${response.reasonPhrase}");
    }
  } catch (e) {
    print("Error updating profile pic: $e");
  }
}

Future<void> updateGoodreadsUrl(String userId, String goodreadsUrl) async {
  final url = Uri.parse("$baseUrl/user/$userId/update_goodreads");

  try {
    final http.Response response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "goodreadsUrl": goodreadsUrl,
      }),
    );

    if (response.statusCode == 200) {
      print("Goodreads link updated successfully");
    } else {
      print("Failed to update Goodreads link: ${response.reasonPhrase}");
    }
  } catch (e) {
    print("Error updating Goodreads link: $e");
  }
}

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

Future<void> uploadArt(String userId, String title, String description,
    String bookId, String imageUrl, String bookCategory) async {
  final url = Uri.parse("$baseUrl/art/upload");

  final body = jsonEncode({
    "userId": userId,
    "title": title,
    "description": description,
    "bookId": bookId,
    "imageUrl": imageUrl,
    "bookCategory": bookCategory,
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

Future<void> deleteArt(String userId, String artId) async {
  final url = Uri.parse("$baseUrl/art/delete/$artId");

  final http.Response response = await http.delete(url);

  if (response.statusCode == 200) {
    print("Artwork deleted successfully");
  } else {
    throw Exception("Failed to delete artwork");
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

Future<void> uploadCover(String userId, String title, String description,
    String bookId, String imageUrl, String bookCategory) async {
  final url = Uri.parse("$baseUrl/covers/upload");

  final headers = {
    "Content-Type": "application/json",
  };

  final body = jsonEncode({
    "userId": userId,
    "title": title,
    "description": description,
    "bookId": bookId,
    "imageUrl": imageUrl,
    "bookCategory": bookCategory,
  });

  final http.Response response =
      await http.post(url, headers: headers, body: body);

  if (response.statusCode == 201) {
    print("Cover uploaded successfully");
  } else {
    throw Exception("Failed to upload cover to the server");
  }
}

Future<void> deleteCover(String userId, String coverId) async {
  final url = Uri.parse("$baseUrl/covers/delete/$coverId");

  final http.Response response = await http.delete(url);

  if (response.statusCode == 200) {
    print("Cover deleted successfully");
  } else {
    throw Exception("Failed to delete cover");
  }
}

/* ------------------ Fetch All Posts ------------------ */

Future<List<Map<String, dynamic>>> getAllPosts() async {
  final artResponse = await http.get(Uri.parse("$baseUrl/art/all"));
  final coversResponse = await http.get(Uri.parse("$baseUrl/covers/all"));

  if (artResponse.statusCode == 200 && coversResponse.statusCode == 200) {
    final artData = jsonDecode(artResponse.body) as List;
    final coversData = jsonDecode(coversResponse.body) as List;

    // for (var art in artData) {
    //   art['type'] =
    //       'art'; // Adding a type key to distinguish between art and cover posts
    // }

    // for (var cover in coversData) {
    //   cover['type'] = 'cover';
    // }

    print("------------ Posts -----------");
    print([...artData, ...coversData].toString());
    return [...artData, ...coversData];
  } else {
    throw Exception("Failed to load posts.");
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

  if (response.statusCode == 200) {
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
    print("Failed to follow book. Status code: ${response.statusCode}");
    print("Response body: ${response.body}");
    throw Exception("Failed to follow book");
  }
}

Future<void> unfollowBook(String userId, String followingId) async {
  final url = Uri.parse("$baseUrl/unfollow_book/$userId/$followingId");

  final http.Response response = await http.delete(url);

  if (response.statusCode == 200) {
    print("Book unfollowed successfully");
  } else {
    print("Failed to unfollow book. Status code: ${response.statusCode}");
    throw Exception("Failed to unfollow book");
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

Future<List<dynamic>> getFollowersByUser(String userId) async {
  final Uri url = Uri.parse("$baseUrl/user/$userId/followers");

  try {
    final http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data as List<dynamic>;
    } else {
      throw Exception("Failed to get followers");
    }
  } catch (e) {
    throw Exception("Failed to get followers: $e");
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

Future<List<dynamic>> getFollowingArtistsByUser(String userId) async {
  final Uri url = Uri.parse("$baseUrl/user/$userId/following_users");

  try {
    final http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // List<String> followingIds = List<String>.from(data);
      print("Following artists response body: ${response.body}");
      // print("Following artists: $followingIds");
      // return followingIds;
      return data as List<dynamic>;
    } else {
      throw Exception("Failed to get following artists");
    }
  } catch (e) {
    throw Exception("Failed to get following artists: $e");
  }
}

Future<List<dynamic>> getFollowingBooksByUser(String userId) async {
  final Uri url = Uri.parse("$baseUrl/user/$userId/following_books");

  try {
    final http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // List<String> followingIds = List<String>.from(data);
      print("Following books response body: ${response.body}");
      // print("Following books: $followingIds");

      // return followingIds;
      return data as List<dynamic>;
    } else {
      throw Exception("Failed to get following books");
    }
  } catch (e) {
    throw Exception("Failed to get following books: $e");
  }
}

Future<bool> isFollowingUser(String userId, String followingId) async {
  print("user_id: $userId");
  print("following_id: $followingId");
  final http.Response response = await http.get(Uri.parse(
      "$baseUrl/check_follow/user?user_id=$userId&following_id=$followingId"));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    print('response: ${data["isFollowing"]}');
    return data["isFollowing"];
  } else {
    throw Exception("Failed to check follow status");
  }
}

Future<bool> isFollowingBook(String userId, String followingId) async {
  final http.Response response = await http.get(Uri.parse(
      "$baseUrl/check_follow/book?user_id=$userId&following_id=$followingId"));

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

  if (response.statusCode == 200) {
    print("Artwork unliked successfully");
  } else {
    print("Status code: ${response.statusCode}");
    throw Exception("Failed to unlike artwork");
  }
}

Future<void> unlikeCover(String userId, String coverId) async {
  final url = Uri.parse("$baseUrl/unlike_cover/$userId/$coverId");

  final http.Response response = await http.delete(url);

  if (response.statusCode == 200) {
    print("Cover unliked successfully");
  } else {
    throw Exception("Failed to unlike cover");
  }
}

Future<bool> isLikedArt(String userId, String artId) async {
  final http.Response response = await http
      .get(Uri.parse("$baseUrl/check_like/art?user_id=$userId&art_id=$artId"));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data["isLiked"];
  } else {
    throw Exception("Failed to check like status");
  }
}

Future<bool> isLikedCover(String userId, String coverId) async {
  final http.Response response = await http.get(
      Uri.parse("$baseUrl/check_like/cover?user_id=$userId&art_id=$coverId"));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data["isLiked"];
  } else {
    throw Exception("Failed to check like status");
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
    print("Artwork bookmarked successfully");
  } else {
    throw Exception("Failed to bookmark artwork");
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
    print("Cover bookmarked successfully");
  } else {
    throw Exception("Failed to bookmark cover");
  }
}

Future<void> unbookmarkArt(String userId, String artId) async {
  final url = Uri.parse("$baseUrl/unbookmark_art/$userId/$artId");

  final http.Response response = await http.delete(url);

  if (response.statusCode == 200) {
    print("Removed bookmark from artwork successfully");
  } else {
    throw Exception("Failed to remove bookmark from artwork");
  }
}

Future<void> unbookmarkCover(String userId, String coverId) async {
  final url = Uri.parse("$baseUrl/unbookmark_cover/$userId/$coverId");

  final http.Response response = await http.delete(url);

  if (response.statusCode == 200) {
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

Future<bool> isBookmarkedArt(String userId, String artId) async {
  final http.Response response = await http.get(
      Uri.parse("$baseUrl/check_bookmark/art?user_id=$userId&art_id=$artId"));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data["isBookmarked"];
  } else {
    throw Exception("Failed to check bookmark status");
  }
}

Future<bool> isBookmarkedCover(String userId, String coverId) async {
  final http.Response response = await http.get(Uri.parse(
      "$baseUrl/check_bookmark/cover?user_id=$userId&cover_id=$coverId"));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data["isBookmarked"];
  } else {
    throw Exception("Failed to check bookmark status");
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
