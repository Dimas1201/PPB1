import 'package:hive/hive.dart';
import '../models/todo.dart';

class Storage {
  static Future<List<Todo>> loadTodos() async {
    final box = await Hive.openBox<Todo>('todoBox');

    // Mengambil semua todos dari box
    return box.values.toList();
  }

  static Future<void> saveTodos(List<Todo> todos) async {
    final box = await Hive.openBox<Todo>('todoBox');

    // Menghapus semua data sebelumnya
    await box.clear();

    // Menyimpan todos ke Hive box
    for (var todo in todos) {
      await box.add(todo);
    }
  }
}
