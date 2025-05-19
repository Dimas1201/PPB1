import 'package:flutter/material.dart';
import '../models/book.dart';
import '../utils/storage.dart';
import 'home.dart';
import '../services/notification_service.dart';

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
  final _imageUrlController = TextEditingController();

  bool _showForm = false;

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
        imageUrl: _imageUrlController.text,
      );
      setState(() {
        books.add(book);
        _showForm = false;
      });
      await Storage.saveBooks(books);

      await NotificationService.createNotification(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        title: 'Book Added',
        body: 'Title: ${book.storytitle}',
      );

      _titleController.clear();
      _descriptionController.clear();
      _imageUrlController.clear();
    }
  }

  void _editBook(int index) async {
    final editedBook = books[index];

    _titleController.text = editedBook.storytitle;
    _descriptionController.text = editedBook.description;
    _imageUrlController.text = editedBook.imageUrl;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Book'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final newBook = Book(
                  storytitle: _titleController.text,
                  description: _descriptionController.text,
                  imageUrl: _imageUrlController.text,
                );
                setState(() {
                  books[index] = newBook;
                });
                await Storage.saveBooks(books);

                await NotificationService.createNotification(
                  id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
                  title: 'Book Edited',
                  body: 'Title: ${newBook.storytitle}',
                );

                _titleController.clear();
                _descriptionController.clear();
                _imageUrlController.clear();

                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteBook(int index) async {
    final deletedBook = books[index];

    setState(() {
      books.removeAt(index);
    });
    await Storage.saveBooks(books);
    await NotificationService.createNotification(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: 'Deleted Book',
      body: 'Title: ${deletedBook.storytitle}',
    );
  }

  void _navigateToHome() {
    if (!context.mounted) return;
    Navigator.pushReplacementNamed(context, 'home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Story Base'),
        backgroundColor: Colors.yellow,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: _navigateToHome,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_showForm) ...[
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _addBook,
                child: const Text('Add Book'),
              ),
              const SizedBox(height: 20),
            ],
            Expanded(
              child: ListView.builder(
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final book = books[index];
                  return Card(
                    child: ListTile(
                      leading: book.imageUrl.isNotEmpty
                          ? Image.network(
                        book.imageUrl,
                        width: 50,
                        height: 75,
                        fit: BoxFit.cover,
                      )
                          : const Icon(Icons.book, size: 50),
                      title: Text(book.storytitle),
                      subtitle: Text('Description: ${book.description}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editBook(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteBook(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _showForm = !_showForm;
          });
        },
        child: Icon(_showForm ? Icons.close : Icons.add),
        tooltip: _showForm ? 'Close Form' : 'Add New Book',
      ),
    );
  }
}
