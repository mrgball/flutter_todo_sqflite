import 'package:flutter_todo_sqlite/database/db_helper.dart';
import 'package:flutter_todo_sqlite/model/todo_model.dart';

class TodoRepository {
  final dbHelper = DBHelper.dbHero;

  Future<int> insert(Todo todo) async {
    return await dbHelper.insertDb(todo.toMap());
  }

  Future<List<Todo>> getAllTodos() async {
    final List<Map<String, dynamic>> maps = await dbHelper.readDb();

    return List.generate(
      maps.length,
      (index) => Todo(
        id: maps[index]['id'],
        name: maps[index]['name'],
        description: maps[index]['description'],
      ),
    );
  }

  Future<int> update(Todo todo) async {
    return await dbHelper.updateDb(todo.toMap());
  }

  Future<int> delete(int id) async {
    return await dbHelper.deleteDb(id);
  }
}
