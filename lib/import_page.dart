//   import_page.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
//import 'package:csv/csv.dart';


class ImportPage extends StatelessWidget {
  const ImportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Import Books"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _importBooks(context);
          },
          child: const Text("Import Books from JSON"),
        ),
      ),
    );
  }

  Future<void> _importBooks(BuildContext context) async {
    try {
      // 1. Load the JSON file
      final String jsonString = await rootBundle.loadString('assets/books.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      // 2. Get a reference to the Firestore collection
      final CollectionReference booksCollection = FirebaseFirestore.instance.collection('books');

      // 3. Iterate through the books and add them to Firestore
      for (final bookId in jsonData.keys) {
        final bookData = jsonData[bookId] as Map<String, dynamic>;


        // Check if the book already exists
        final bookQuery = await booksCollection.doc(bookId).get();
        if (!bookQuery.exists) {
          // Create a new map with only the desired fields
          final newBookData = {
            'title': bookData['title'],
            'authors': bookData['authors'],
            'isbn': bookData['isbn'],
            'format': bookData['format'],
            'language': bookData['language'],
            'publication': bookData['publication'],
            'pages': bookData['pages'],
            'date': bookData['date'],
            'summary': bookData['summary'],
            'genre': bookData['genre'],

            'checkedOutBy': {}, // Add checkedOutBy field with an empty map
          };
          await booksCollection.doc(bookId).set(newBookData); // Use newBookData here
        }
      }

      // 4. Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Books imported successfully!')),
      );
    } catch (e) {
      // 5. Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error importing books: $e')),
      );
    }
  }
}