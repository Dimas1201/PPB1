import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book.dart';

class Storage {
  static final _collection = FirebaseFirestore.instance.collection('books');

  static Future<List<Book>> loadBooks() async {
    final snapshot = await _collection.get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Book.fromJson(data);
    }).toList();
  }

  static Future<void> saveBooks(List<Book> books) async {
    final batch = FirebaseFirestore.instance.batch();
    final snapshot = await _collection.get();

    // daokumen lama dihapus
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    // data baru ditambahkan
    for (var book in books) {
      final docRef = _collection.doc();
      batch.set(docRef, book.toJson());
    }

    await batch.commit();
  }
}
