import 'package:flutter/material.dart';
import 'package:flutter_todo_sqlite/database/todo_repository.dart';
import 'package:flutter_todo_sqlite/model/todo_model.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TodoRepository _todoRepository = TodoRepository();

  List<Todo> _todos = [];

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  void _loadTodos() async {
    final todos = await _todoRepository.getAllTodos();
    setState(() {
      _todos = todos;
    });
  }

  void _addTodo() async {
    final name = _nameController.text;
    final description = _descriptionController.text;

    if (name.isEmpty && description.isEmpty) return;

    final todo = Todo(name: name, description: description);
    await _todoRepository.insert(todo);

    _nameController.clear();
    _descriptionController.clear();
    _loadTodos();
  }

  void _updateTodo(Todo todo) async {
    final updatedTodo = Todo(
      id: todo.id,
      name: _nameController.text,
      description: _descriptionController.text,
    );

    await _todoRepository.update(updatedTodo);

    _nameController.clear();
    _descriptionController.clear();
    _loadTodos();
  }

  void _deleteTodo(int id) async {
    await _todoRepository.delete(id);

    _loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Todo Name'),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _addTodo(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    textStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 6,
                    shadowColor: Colors.black26,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add, size: 22, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Add Todo'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];
                return ListTile(
                  title: Text(todo.name),
                  subtitle: Text(todo.description),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      _nameController.text = todo.name;
                      _descriptionController.text = todo.description;
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('Edit Todo'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: _nameController,
                                decoration:
                                    InputDecoration(labelText: 'Todo Name'),
                              ),
                              TextField(
                                controller: _descriptionController,
                                decoration:
                                    InputDecoration(labelText: 'Description'),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                _updateTodo(todo);
                                Navigator.of(context).pop();
                              },
                              child: Text('Update'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text('Delete Todo'),
                        content:
                            Text('Are you sure you want to delete this todo?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              _deleteTodo(todo.id!);
                              Navigator.of(context).pop();
                            },
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
