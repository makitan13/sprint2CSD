class Category {
  final String categoryName;

  Category({
    required this.categoryName,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryName: json['category_name'],
    );
  }

  get name => null;
}
