# todo

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Migrate data using HIVE Database
1. Instalasi Hive dan Hive Flutter: Jika belum melakukannya, pastikan kamu telah menambahkan dependensi yang diperlukan di pubspec.yaml
   `dependencies:
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  path_provider: ^2.1.5`

2. Inisialisasi Hive: Di dalam main.dart, kamu perlu menginisialisasi Hive terlebih dahulu agar bisa digunakan dalam aplikasi.
   ` import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';  // Impor Hive
import 'screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Hive
  await Hive.initFlutter();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'To Do List',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainScreen(),
    );
  }
} `

3. Membuat Box untuk Menyimpan Data: Selanjutnya, kamu perlu membuat box (semacam tabel) untuk menyimpan data Todo kamu menggunakan Hive. Setiap Todo akan disimpan dalam box.
   `import 'package:hive/hive.dart';

part 'todo.g.dart';  // Agar bisa generate adapter

@HiveType(typeId: 0)
class Todo {
  @HiveField(0)
  String title;

  @HiveField(1)
  bool isCompleted;

  @HiveField(2)
  bool isEditing;

  Todo({
    required this.title,
    this.isCompleted = false,
    this.isEditing = false,
  });`

  4. Jangan lupa untuk menjalankan perintah flutter packages pub run build_runner build untuk menghasilkan file todo.g.dart.
  5. Menggunakan Hive untuk Menyimpan dan Mengambil Data: Setelah Hive diinisialisasi, kamu bisa mengubah bagian penyimpanan dan 
     pengambilan data dari SharedPreferences menjadi menggunakan Hive.

     Perbarui storage.dart untuk menggunakan Hive:
     `import 'package:hive/hive.dart';
import 'todo.dart';

class Storage {
  static Future<List<Todo>> loadTodos() async {
    var box = await Hive.openBox<Todo>('todos'); // Membuka box 'todos'
    return box.values.toList();  // Mengambil semua data dari box
  }

  static Future<void> saveTodos(List<Todo> todos) async {
    var box = await Hive.openBox<Todo>('todos');  // Membuka box 'todos'
    await box.clear();  // Menghapus data lama sebelum menyimpan yang baru
    await box.addAll(todos);  // Menambahkan semua todos ke box
  }
}`

6. Menggunakan Hive di MainScreen:
   Pastikan kamu memanggil fungsi Storage.loadTodos() di MainScreen untuk memuat dan menampilkan data todo yang disimpan menggunakan 
   Hive.
7. Pastikan semua sharedpreference diubah menjadi HIVE database
