//admin_screen.dart

import 'package:flutter/material.dart';
import 'barcode_scanner_screen.dart'; // Import your barcode scanner screen
import 'book_api.dart'; // Import your book API functions
import 'database_helper.dart';
import 'edit_inventory_page.dart'; // Import your database helper

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
        title: const Text('Admin Panel'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Align buttons vertically in the center
        children: [
          const SizedBox(height: 20),
          const Center(
            child: Text(
              "Inventory Management",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 40),

          // Add to Inventory Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BarcodeScannerScreen()),
                  );

                  if (result!= null) {
                    String scannedBarcode = result as String;
                    try {
                      final bookData =
                      await searchForBookData(scannedBarcode); // Call searchForBookData
                      await dbHelper
                          .addBook(bookData!); // Call addBook
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Book added!')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Error adding book: $e')), // Show error
                      );
                    }
                  }
                },
                child: const Text('Add to Inventory'),
              ),
            ),
          ),

          // Edit Inventory Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to EditInventoryPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EditInventoryPage()),
                  );
                },
                child: const Text('Edit Inventory'),
              ),
            ),
          ),

          // Check In/Out Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle Check In/Out
                },
                child: const Text('Check In/Out'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}