import 'package:flutter/material.dart';
import '../models/book.dart';
import '../utils/storage.dart';

class MainScreen extends StatefulWidget {
  final String theme;
  const MainScreen({Key? key, required this.theme}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Book> books = [];

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();  // Controller untuk URL gambar

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  void _loadBooks() async {
    final data = await Storage.loadBooks();
    setState(() {
      books = data;
    });
  }

  void _addBook() async {
    if (_titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty &&
        _imageUrlController.text.isNotEmpty) {
      final book = Book(
        storytitle: _titleController.text,
        description: _descriptionController.text,
        imageUrl: _imageUrlController.text,  // Ambil URL gambar
      );
      setState(() {
        books.add(book);
      });
      await Storage.saveBooks(books);
      _titleController.clear();
      _descriptionController.clear();
      _imageUrlController.clear();  // Kosongkan field URL gambar
    }
  }


  void _deleteBook(int index) async {
    setState(() {
      books.removeAt(index);
    });
    await Storage.saveBooks(books);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Story Base'),
        backgroundColor: Colors.yellow,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'description'),
            ),
            TextField(
              controller: _imageUrlController,  // Input URL gambar
              decoration: const InputDecoration(labelText: 'Image URL'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addBook,
              child: const Text('Add Book'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final book = books[index];
                  return Card(
                    child: ListTile(
                      leading: book.imageUrl.isNotEmpty
                          ? Image.network(book.imageUrl, width: 50, height: 75, fit: BoxFit.cover)
                          : const Icon(Icons.book, size: 50),
                      title: Text(book.storytitle),
                      subtitle: Text('description: ${book.description}\n'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),

                        onPressed: () => _deleteBook(index),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

