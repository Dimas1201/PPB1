class Book {
  String storytitle;
  String description;
  String imageUrl;

  Book({
    required this.storytitle,
    required this.description,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'storytitle': storytitle,
      'description': description,
      'imageUrl': imageUrl,
    };
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      storytitle: json['storytitle'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
