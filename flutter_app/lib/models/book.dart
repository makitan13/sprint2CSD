class Book {
  final int id;
  final String categoryName;
  final String title;
  final String author;
  final String isbn;
  final String publishedDate;
  final String? coverImage;
  final String? description;

  Book(
      {required this.id,
      required this.categoryName,
      required this.title,
      required this.author,
      required this.isbn,
      required this.publishedDate,
      this.coverImage,
      this.description});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      categoryName: json['category_name'],
      title: json['title'],
      author: json['author'],
      isbn: json['isbn'],
      publishedDate: json['published_date'],
      coverImage: json['cover_image'],
      description: json['description'],
    );
  }
}
