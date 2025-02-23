//  profile_page.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'edit_profile_page.dart';
import 'favorites_page.dart';
import 'holds_page.dart';
import 'saved_page.dart';
import 'book_details_page.dart'; // Import BookDetailsPage

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<String> checkedOut = [];
  List<Map<String, dynamic>> youMayAlsoLike = [];
  List<String> badges = [];

  @override
  void initState() {
    super.initState();
    // Initialize checkedOut, youMayAlsoLike, and badges here if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LPCC Library"),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfilePage()),
              );
            },
            child: const Text("Edit Profile"),
          ),
        ],
      ),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data;
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user!.uid)
                  .get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.hasData) {
                  final userData = userSnapshot.data!.data() as Map<String, dynamic>;
                  // Update checkedOut list
                  checkedOut = List<String>.from(userData['checkedOut']??[]);
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Center(
                          child: Column(
                            children: [
                              const CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(
                                    "https://www.seekpng.com/png/full/115-1150053_avatar-png-transparent-png-royalty-free-default-avatar.png"),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                userData['username']?? 'Unknown Username',
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                  'Member Since: ${userData['memberSince']?? 'Unknown'}'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Library Card Number:',
                                style: TextStyle(fontSize: 18),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                userData['libraryCardNumber'].toString(),
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildIconWithText(
                              'assets/images/hold_icon.png',
                              'Holds',
                                  () =>
                                  _navigateToPage(context, const HoldsPage()),
                            ),
                            _buildIconWithText(
                              'assets/images/favorite_icon.png',
                              'Favorites',
                                  () => _navigateToPage(
                                  context, const FavoritesPage()),
                            ),
                            _buildIconWithText(
                              'assets/images/save_book_icon_two.png',
                              'Saved',
                                  () =>
                                  _navigateToPage(context, const SavedPage()),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Currently Checked Out:'),
                              Text(userData['currentlyCheckedOut'].toString()),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total Books Checked Out:'),
                              Text(userData['totalBooksCheckedOut'].toString()),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Overdue/Late:'),
                              Text(userData['lateReturns'].toString()),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Currently Checked-Out',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Currently Checked Out Books
                        _buildCurrentlyCheckedOutBooks(checkedOut),
                        const SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'You may also like:',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // You may also like section (horizontal listview)
                        _buildYouMayAlsoLike(),
                        const SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Badges:',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Badges section (horizontal listview)
                        _buildBadges(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                } else if (userSnapshot.hasError) {
                  return Center(
                    child: Text('Error: ${userSnapshot.error}'),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            );
          } else {
            return const Center(
              child: Text('User not logged in'),
            );
          }
        },
      ),
    );
  }

  Widget _buildCurrentlyCheckedOutBooks(List<dynamic> checkedOut) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: checkedOut.length,
      itemBuilder: (context, index) {
        final bookId = checkedOut[index] as String;
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('books')
              .doc(bookId)
              .get(),
          builder: (context, bookSnapshot) {
            if (bookSnapshot.hasError) {
              return ListTile(
                  title: Text('Error: ${bookSnapshot.error}'));
            }

            if (bookSnapshot.connectionState ==
                ConnectionState.waiting) {
              return const ListTile(title: Text('Loading...'));
            }

            final bookData =
            bookSnapshot.data!.data() as Map<String, dynamic>;
            final imageLinks =
            bookData['imageLinks'] as Map<String, dynamic>?;
            final imageUrl = imageLinks?['thumbnail'] as String?;
            return ListTile(
              leading: SizedBox(
                width: 50,
                height: 50,
                child: imageUrl!= null
                    ? Image.network(imageUrl)
                    : const Icon(Icons.book),
              ),
              title: Text(bookData['title']?? 'Unknown Title'),
              subtitle: Text(bookData['authors']?.join(', ')?? 'Unknown Author'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookDetailsPage(bookData: bookData),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
  Widget _buildYouMayAlsoLike() {
    return SizedBox(
      height: 200,
      child: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collection('books').limit(5).get(), // Fetch 5 random books
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Text('No books found');
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final bookData = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              final imageLinks = bookData['imageLinks'] as Map<String, dynamic>?;
              final imageUrl = imageLinks?['thumbnail'] as String?;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailsPage(bookData: bookData),
                      ),
                    );
                  },
                  child: imageUrl!= null
                      ? Image.network(imageUrl, fit: BoxFit.cover)
                      : const Icon(Icons.book, size: 100),
                ),
              );
            },
          );
        },
      ),
    );
  }
  Widget _buildBadges() {
    // Replace with your actual badge logic
    List<String> badgeUrls = [
      "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Gold_Star.svg/1200px-Gold_Star.svg.png",
      "https://cdn-icons-png.flaticon.com/512/2107/2107957.png",
      "https://cdn-icons-png.flaticon.com/512/2107/2107957.png",
    ];
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: badgeUrls.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(badgeUrls[index], fit: BoxFit.cover),
          );
        },
      ),
    );
  }

  Widget _buildIconWithText(
      String imagePath, String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(
            imagePath,
            height: 50,
          ),
          const SizedBox(height: 8),
          Text(text),
        ],
      ),
    );
  }

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }
}