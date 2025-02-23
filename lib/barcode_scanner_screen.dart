//barcode_scanner_screen.dart

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'book_api.dart';

class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  String? barcode;
  MobileScannerController? controller;
  bool isScanning = true; // Track scanning state

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcode Scanner'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('User data not found'));
          }
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          if (userData['isAdmin'] == true) {
            // User is admin, show the scanner
            return Stack(
              children: [
                MobileScanner(
                  controller: controller,
                  fit: BoxFit.cover,
                  onDetect: (barcodeCapture) async {
                    if (isScanning) {
                      setState(() {
                        barcode = barcodeCapture.barcodes.first.rawValue;
                        isScanning = false;
                      });
                      if (barcode!= null) {
                        controller?.stop();
                        try {
                          // Search for book data across multiple APIs (call the function from book_api.dart)
                          final bookData = await searchForBookData(barcode!);

                          if (bookData!= null) {
                            // Store book data in Firestore
                            await FirebaseFirestore.instance
                                .collection('books')
                                .doc(barcode)
                                .set(bookData);
                            // Show a success message
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Book added to database!')),
                            );
                          } else {
                            // Show an error message
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Book not found')),
                            );
                          }
                        } catch (e) {
                          // Show an error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error adding book: $e')),
                          );
                        }
                        Navigator.pop(context, barcode);
                      }
                    }
                  },
                ),
                Center(
                  child: isScanning
                      ? const Text(
                    "Scanning...",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )
                      : const SizedBox.shrink(),
                ),
              ],
            );
          } else {
            // User is not admin, show a message
            return const Center(
              child: Text('You do not have permission to scan books.'),
            );
          }
        },
      ),
    );
  }
}