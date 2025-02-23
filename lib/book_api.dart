//book_api.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
//import 'package:web_scraper/web_scraper.dart';

// Function to search for book data across multiple APIs
Future<Map<String, dynamic>?> searchForBookData(String isbn) async {
  // 1. Try Google Books API
  try {
    final bookData = await fetchBookDataFromGoogle(isbn);
    if (bookData != null) {
      return bookData;
    }
  } catch (e) {
    // Log the error and continue to the next API
    print('Error fetching from Google Books API: $e');
  }

  // 2. Try Open Library API
  try {
    final bookData = await fetchBookDataFromOpenLibrary(isbn);
    if (bookData != null) {
      return bookData;
    }
  } catch (e) {
    // Log the error and continue to the next API
    print('Error fetching from Open Library API: $e');
  }

  // 3. Try other APIs (if available)
  //...

  // 4. If no results from any API, return null
  return null;
}

// Function to fetch book data from Google Books API
Future<Map<String, dynamic>?> fetchBookDataFromGoogle(String isbn) async {
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

        'dateAdded': DateTime.now().toString(), // Add dateAdded field

        'checkedOutBy': {}, // Add checkedOutBy field with an empty map'

        'checkedInBy': {},

      };
    } else {
      return null; // Book not found
    }
  } else {
    throw Exception('Failed to fetch book data from Google Books API');
  }
}

// Function to fetch book data from Open Library API
Future<Map<String, dynamic>?> fetchBookDataFromOpenLibrary(String isbn) async {
  final response = await http.get(
    Uri.parse(
      'https://openlibrary.org/api/books?bibkeys=ISBN:$isbn&jscmd=data&format=json',
    ),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = jsonDecode(response.body);
    final isbnKey = 'ISBN:$isbn';
    if (jsonData.containsKey(isbnKey)) {
      final bookData = jsonData[isbnKey];
      return {
        'title': bookData['title'],
        'authors':
            (bookData['authors'] as List<dynamic>?)
                ?.map((author) => author['name'] as String)
                .toList() ??
            [],
        'publisher': bookData['publishers']?['name'],
        'publishedDate': bookData['publish_date'],
        'description':
            bookData['description'] is String
                ? bookData['description']
                : bookData['description']?['value'],
        'pageCount': bookData['number_of_pages'],
        'categories':
            bookData['subjects']
                ?.map((subject) => subject['name'] as String)
                .toList() ??
            [],
        'averageRating': null, // Open Library API doesn't provide ratings
        'ratingsCount': null,
        'imageLinks': {
          'thumbnail':
              bookData['cover'] != null
                  ? 'https://covers.openlibrary.org/b/id/${bookData['cover']['medium']}-M.jpg'
                  : null,
        },
        'isbn': isbn,
        'dateAdded': DateTime.now().toString(), // Add dateAdded field
        'checkedOutBy': {}, // Add checkedOutBy field with an empty map'
        'checkedInBy': {},
      };
    } else {
      return null; // Book not found
    }
  } else {
    throw Exception('Failed to fetch book data from Open Library API');
  }
}
