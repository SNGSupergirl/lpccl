//loading_page.dart

import 'package:flutter/material.dart';
import 'home_page.dart'; // Import your home page

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    // Simulate loading and navigate to home page
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement( // Use pushReplacement to prevent going back
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4CAF50), // Green background color
      body: Center(
        child: Image.asset(
          'assets/images/library_logo_two.png', // Replace with your logo path
          height: 400, // Adjust height as needed
        ),
      ),
    );
  }
}