import 'package:flutter/material.dart';

class AppErrorView extends StatelessWidget {
  final String message;

  const AppErrorView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}