//admin_screen.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'barcode_scanner_screen.dart'; // Import your barcode scanner screen
import 'book_api.dart'; // Import your book API functions
import 'database_helper.dart';
import 'edit_inventory_page.dart'; // Import your database helper
import 'user_dashboard_page.dart'; // Import the UserDashboardPage

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
        mainAxisAlignment: MainAxisAlignment.center,
        // Align buttons vertically in the center
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

                  if (result != null) {
                    String scannedBarcode = result as String;
                    try {
                      final bookData =
                      await searchForBookData(
                          scannedBarcode); // Call searchForBookData
                      await dbHelper
                          .addBook(bookData!); // Call addBook
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Book added!')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Error adding book: $e')), // Show error
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
                    MaterialPageRoute(
                        builder: (context) => const EditInventoryPage()),
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
                  _showLibraryCardNumberInputDialog(context);
                },
                child: const Text('Check In/Out'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showLibraryCardNumberInputDialog(BuildContext context) async {
    final _formKey = GlobalKey<FormState>();
    final _libraryCardNumberController = TextEditingController();

    await showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button!
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Enter Library Card Number'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: ListBody(
                children: <Widget>[
                  TextFormField(
                    controller: _libraryCardNumberController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Library Card Number',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a library card number';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text('Proceed'),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final libraryCardNumber =
                  int.parse(_libraryCardNumberController.text);
                  // Check if the library card number exists
                  final userQuery = await FirebaseFirestore.instance
                      .collection('users')
                      .where('libraryCardNumber', isEqualTo: libraryCardNumber)
                      .get();
                  if (userQuery.docs.isNotEmpty) {
                    // Navigate to UserDashboardPage
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            UserDashboardPage(
                              userId: userQuery.docs.first.id,
                            ),
                      ),
                    );
                  } else {
                    // Show error message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Library card number not found')),
                    );
                  }
                  // Close the dialog after the navigation or error message
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}