//book_api.dart

import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>> fetchBookData(String isbn) async {
  final url = Uri.parse('https://www.googleapis.com/books/v1/volumes?q=isbn:$isbn'); // Example using Google Books API
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    // Process the JSON data and extract the book information you need
    // ... (e.g., title, author, etc.)
    if (jsonData['items'] != null && jsonData['items'].isNotEmpty) {
      final book = jsonData['items'][0]['volumeInfo'];
      return {
        'title': book['title'],
        'author': book['authors'] != null ? book['authors'][0] : 'Unknown',
        'isbn': isbn, // Make sure to include the isbn
        // ... other book data
      };
    } else {
      throw Exception('Book not found');
    }
  } else {
    throw Exception('Failed to fetch book data');
  }
}