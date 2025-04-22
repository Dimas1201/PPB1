import 'package:hive/hive.dart';

part 'book.g.dart'; // Jangan lupa untuk menambahkan part untuk file yang di-generate

@HiveType(typeId: 0)
class Book extends HiveObject {
  @HiveField(0)
  String storytitle;

  @HiveField(1)
  String description;

  @HiveField(2)
  String imageUrl;  // Field baru untuk menyimpan URL gambar

  Book({
    required this.storytitle,
    required this.description,
    required this.imageUrl, // Tambahkan imageUrl di constructor
  });

  Map<String, dynamic> toJson() {
    return {
      'storytitle': storytitle,
      'description': description,
      'imageUrl': imageUrl,  // Tambahkan imageUrl ke map
    };
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      storytitle: json['storytitle'],
      description: json['description'],
      imageUrl: json['imageUrl'],  // Ambil imageUrl dari json
    );
  }
}
