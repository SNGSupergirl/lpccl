import 'package:flutter/material.dart';
import 'loading_page.dart'; // Import your loading page
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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