import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        context.go('/dashboard');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF111827),
              Color(0xFF1F2937),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.local_fire_department,
                  size: 80,
                  color: Colors.blueAccent),
              SizedBox(height: 24),
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                "Bereite dein Dashboard vor...",
                style: TextStyle(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}