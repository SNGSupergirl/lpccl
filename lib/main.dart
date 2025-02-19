import 'package:flutter/material.dart';
import 'loading_page.dart'; // Import your loading page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LPCC Library App', // Give your app a title
      debugShowCheckedModeBanner: false, // Remove the debug banner (optional)
      home: const LoadingPage(), // Set LoadingPage as the initial route
    );
  }
}