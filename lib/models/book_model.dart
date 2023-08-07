class Book {
  final String id;
  final String title;
  final String author;
  final String thumbnailUrl;
  final String publishedDate;
  final int pageCount;
  final String description;
  final List<String> categories;


  Book(
      {required this.id,
      required this.title,
      required this.author,
      required this.thumbnailUrl,
      required this.publishedDate,
      required this.pageCount,
      required this.description,
      required this.categories});

  factory Book.fromJson(Map<String, dynamic> json) {
    List<String> categories = [];
    if (json['volumeInfo'] != null && json['volumeInfo']['categories'] != null
        && json['volumeInfo']['categories'].isNotEmpty) {
      categories = List<String>.from(json['volumeInfo']['categories']);
    }
    
    return Book(
      id: json['id'] ?? "Id not available",
      title: json['volumeInfo']['title'] ?? "Title not available",
      author: (json['volumeInfo']['authors'] != null &&
              json['volumeInfo']['authors'].isNotEmpty)
          ? json['volumeInfo']['authors'][0]
          : "Author not available",
      thumbnailUrl: json['volumeInfo']['imageLinks'] != null
          ? json['volumeInfo']['imageLinks']['thumbnail']
          : "images/search_placeholder_image.jpg",
      publishedDate: json['volumeInfo']['publishedDate'] ?? "No release date",
      pageCount: json['volumeInfo']['pageCount'] ?? 0,
      description:
          json['volumeInfo']['description'] ?? "No synopsis available",
      categories: categories,
    );
  }
}
