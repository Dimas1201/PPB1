import 'package:hive/hive.dart';
import '../models/book.dart';

class Storage {
  static Future<List<Book>> loadBooks() async {
    final box = await Hive.openBox<Book>('bookBox');
    return box.values.toList();  // Mengambil data dari box
  }

  static Future<void> saveBooks(List<Book> books) async {
    final box = await Hive.openBox<Book>('bookBox');
    await box.clear();  // Hapus data yang lama sebelum menyimpan yang baru
    for (var book in books) {
      await box.add(book);  // Simpan data buku ke box
    }
  }
}
