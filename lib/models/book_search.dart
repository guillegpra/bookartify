class Book {
  final String title;
  final String author;
  final String thumbnailUrl;
  final String publishedDate;
  final int pageCount;
  final String description; // added

  Book(
      {required this.title,
      required this.author,
      required this.thumbnailUrl,
      required this.publishedDate,
      required this.pageCount,
      required this.description});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
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
          json['volumeInfo']['description'] ?? "No synopsis available", // added
    );
  }
}
