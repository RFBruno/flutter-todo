import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todolist/models/todo.dart';

class TodoListItem extends StatelessWidget {
  const TodoListItem({ Key? key, required this.todo }) : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: Colors.black12,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('dd/MM/yyyy - HH:mm').format(todo.dateTime),
            style: const TextStyle(
              fontSize: 12
            ),
            ),
          Text(
            todo.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600
            ),
            ),
        ],
      ),
    );
  }
}