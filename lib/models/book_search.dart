class Book {
  final String title;
  final String author;
  final String description;
  final String thumbnailUrl;

  Book({
    required this.title,
    required this.author,
    required this.description,
    required this.thumbnailUrl,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['volumeInfo']['title'] ?? 'Unknown Title',
      author: (json['volumeInfo']['authors'] != null)
          ? json['volumeInfo']['authors'].join(', ')
          : 'Unknown Author',
      description: json['volumeInfo']['description'] ?? 'No description available',
      thumbnailUrl: json['volumeInfo']['imageLinks'] != null && json['volumeInfo']['imageLinks']['smallThumbnail'] != null
          ? json['volumeInfo']['imageLinks']['smallThumbnail']
          : 'images/search_placeholder_image.jpg', //add a placeholder image URL here
    );
  }
}
