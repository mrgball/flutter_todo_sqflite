import 'package:flutter/material.dart';
import 'package:flutter_todo_sqlite/screen/todo_list_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo SQFLITE',
      theme: ThemeData(
        primaryColor: Colors.purpleAccent,
      ),
      home: TodoListScreen(),
    );
  }
}
