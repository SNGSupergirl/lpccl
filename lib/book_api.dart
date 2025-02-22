//book_api.dart

import 'package:http/http.dart' as http;
import 'dart:convert';

Future<Map<String, dynamic>?> fetchBookData(String isbn) async {
  final response = await http.get(
    Uri.parse('https://www.googleapis.com/books/v1/volumes?q=isbn:$isbn'),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = jsonDecode(response.body);
    if (jsonData['totalItems'] > 0) {
      final item = jsonData['items'][0]; // Access the first item in the list
      final volumeInfo = item['volumeInfo'];
      return {
        'title': volumeInfo['title'],
        'authors': volumeInfo['authors']?.cast<String>() ?? [],
        'publisher': volumeInfo['publisher'],
        'publishedDate': volumeInfo['publishedDate'],
        'description': volumeInfo['description'],
        'pageCount': volumeInfo['pageCount'],
        'categories': volumeInfo['categories']?.cast<String>() ?? [],
        'averageRating': volumeInfo['averageRating'],
        'ratingsCount': volumeInfo['ratingsCount'],
        'imageLinks': volumeInfo['imageLinks'] ?? {},
        'isbn': isbn,
      };
    } else {
      return null; // Book not found
    }
  } else {
    throw Exception('Failed to fetch book data');
  }
}