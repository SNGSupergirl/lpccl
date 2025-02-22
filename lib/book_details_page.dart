//  book_details_page.dart

import 'package:flutter/material.dart';

class BookDetailsPage extends StatelessWidget {
  final Map<String, dynamic> bookData;

  const BookDetailsPage({Key? key, required this.bookData}): super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageLinks = bookData['imageLinks'] as Map<String, dynamic>?;
    final imageUrl = imageLinks?['thumbnail'] as String?;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Details"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              width: double.infinity,
              child: imageUrl!= null
                  ? Image.network(imageUrl, fit: BoxFit.cover)
                  : const Icon(Icons.book, size: 100),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bookData['title'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'by ${bookData['authors'].join(', ')}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Description:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(bookData['description']?? 'No description available.'),
                  const SizedBox(height: 16),
                  // Add more book details here (publisher, publishedDate, etc.)
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle "Put on hold"
                  },
                  child: const Text("Put on Hold"),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle "Favorite"
                  },
                  child: const Text("Favorite"),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle "Save for later"
                  },
                  child: const Text("Save for Later"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}