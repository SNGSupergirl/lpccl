//admin_screen.dart

import 'package:flutter/material.dart';
import 'barcode_scanner_screen.dart'; // Import your barcode scanner screen
import 'book_api.dart'; // Import your book API functions
import 'database_helper.dart'; // Import your database helper

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final dbHelper = DatabaseHelper(); // Initialize your database helper

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
      ),
      body: Center( // Center the button for better UI
        child: ElevatedButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BarcodeScannerScreen()),
            );

            if (result != null) {
              String scannedBarcode = result as String;
              try {
                final bookData = await fetchBookData(scannedBarcode); // Call fetchBookData
                await dbHelper.addBook(bookData!); // Call addBook
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Book added!')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error adding book: $e')), // Show error
                );
              }
            }
          },
          child: Text('Scan Barcode'),
        ),
      ),
    );
  }
}