import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bookartify/models/book_search.dart'; 

class ApiService {
  final String _apiKey = 'AIzaSyBfpzEdp3h9U1S7qyPKpIBj9u_vAggtLjg'; // BookArtify Google Books API key

  Future<List<Book>> fetchBooks(String query) async {
    final response = await http.get(
      Uri.parse(
          'https://www.googleapis.com/books/v1/volumes?q=$query&key=$_apiKey'),
    );

    // // Printing the response body for debugging purposes
    // print('API response: ${response.body}');

    if (response.statusCode == 200) {
      // Successful request
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data.containsKey('items')) {
        final books = data['items'] as List;
        return books.map((bookData) => Book.fromJson(bookData)).toList();
      } else {
        // No books found, returning an empty list
        return [];
      }
    } else {
      // If the request was not successful
      throw Exception('Failed to load books');
    }
  }
}
