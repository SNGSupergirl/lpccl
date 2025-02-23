//  book_details_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart'; // Import the LoginPage

class BookDetailsPage extends StatefulWidget {
  final Map<String, dynamic> bookData;

  const BookDetailsPage({Key? key, required this.bookData}): super(key: key);

  @override
  State<BookDetailsPage> createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  bool _isOnHold = false;
  bool _isFavorite = false;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _loadBookStatus();
  }

  Future<void> _loadBookStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user!= null) {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        _isOnHold =
            (userData['holds'] as List<dynamic>?)?.contains(widget.bookData['isbn'])?? false;
        _isFavorite =
            (userData['favorites'] as List<dynamic>?)?.contains(widget.bookData['isbn'])?? false;
        _isSaved =
            (userData['saved'] as List<dynamic>?)?.contains(widget.bookData['isbn'])?? false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageLinks = widget.bookData['imageLinks'] as Map<String, dynamic>?;
    final imageUrl = imageLinks?['thumbnail'] as String?;


    return Consumer<AppAuthProvider>(
      builder: (context, authProvider, _) {
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
                        widget.bookData['title'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'by ${widget.bookData['authors'].join(', ')}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Description:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(widget.bookData['description']??
                          'No description available.'),
                      const SizedBox(height: 16),
                      // Add more book details here (publisher, publishedDate, etc.)
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (authProvider.isLoggedIn) { // Check if logged in
                              setState(() {
                                _isOnHold =!_isOnHold;
                              });
                              _updateBookStatus(
                                  authProvider.isLoggedIn,
                                  'holds',
                                  _isOnHold,
                                  widget.bookData['isbn']);
                            } else {
                              // Navigate to LoginPage
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                              );
                            }
                          },
                          icon: Image.asset(
                            'assets/images/hold_icon.png',
                            height: 69,
                            width: 69,
                          ),
                        ),
                        Text(_isOnHold? "On Hold": "Place Hold"),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (authProvider.isLoggedIn) { // Check if logged in
                              setState(() {
                                _isFavorite =!_isFavorite;
                              });
                              _updateBookStatus(
                                  authProvider.isLoggedIn,
                                  'favorites',
                                  _isFavorite,
                                  widget.bookData['isbn']);
                            } else {
                              // Navigate to LoginPage
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                              );
                            }
                          },
                          icon: Image.asset(
                            'assets/images/favorite_icon.png',
                            height: 69,
                            width: 69,
                          ),
                        ),
                        Text(_isFavorite? "Favorite": "Add to Favorites"),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (authProvider.isLoggedIn) { // Check if logged in
                              setState(() {
                                _isSaved =!_isSaved;
                              });
                              _updateBookStatus(
                                  authProvider.isLoggedIn,
                                  'saved',
                                  _isSaved,
                                  widget.bookData['isbn']);
                            } else {
                              // Navigate to LoginPage
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                              );
                            }
                          },
                          icon: Image.asset(
                            'assets/images/save_book_icon_two.png',
                            height: 69,
                            width: 69,
                          ),
                        ),
                        Text(_isSaved? "Saved": "Save for Later"),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  Future<void> _updateBookStatus(bool isLoggedIn, String listName,
      bool shouldAdd, String isbn) async {
    if (isLoggedIn) {
      final user = FirebaseAuth.instance.currentUser;
      if (user!= null) {
        final bookRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
        if (shouldAdd) {
          await bookRef.update({
            listName: FieldValue.arrayUnion([isbn])
          });
        } else {
          await bookRef.update({
            listName: FieldValue.arrayRemove([isbn])
          });
        }
      }
    }
  }
}