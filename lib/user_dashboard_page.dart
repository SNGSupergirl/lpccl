//   user_dashboard_page.dart

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'barcode_scanner_screen.dart';

class UserDashboardPage extends StatefulWidget {
  final String userId;

  const UserDashboardPage({Key? key, required this.userId}): super(key: key);

  @override
  _UserDashboardPageState createState() => _UserDashboardPageState();
}

class _UserDashboardPageState extends State<UserDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Dashboard"),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userId)
            .snapshots(),
        builder: (context, userSnapshot) {
          if (userSnapshot.hasError) {
            return Center(child: Text('Error: ${userSnapshot.error}'));
          }

          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final userData = userSnapshot.data!.data() as Map<String, dynamic>;
          final checkedOut = userData['checkedOut'] as List<dynamic>;
          final totalBooksCheckedOut = userData['totalBooksCheckedOut'] as int;
          final lateReturns = userData['lateReturns'] as int;
          final memberSince = userData['memberSince'] as String;

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
                      Text('Member Since: $memberSince'),
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
                ListView.builder(
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
                          title: Text(bookData['title']),
                          subtitle: Text(bookData['authors'].join(', ')),
                          trailing: ElevatedButton(
                            onPressed: () {
                              _checkInBook(bookId, widget.userId);
                            },
                            child: const Text("Check In"),
                          ),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'User History',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Books checked out:'),
                          Text(totalBooksCheckedOut.toString()),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Late Returns:'),
                          Text(lateReturns.toString()),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Notes:'),
                          const SizedBox(
                            width: 100,
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
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
                        'Check-Out',
                        style: TextStyle(fontSize: 18),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          // Navigate to BarcodeScannerScreen
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BarcodeScannerScreen()),
                          );

                          if (result!= null) {
                            final scannedIsbn = result as String;
                            // Check out the book for the user
                            _checkOutBook(scannedIsbn, widget.userId);
                          }
                        },
                        child: const Text("Check-Out"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
  Future<void> _checkInBook(String bookId, String userId) async {
    try {
      // Remove the book from the user's checkedOut array
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({
        'checkedOut': FieldValue.arrayRemove([bookId]),
      });

      // Remove the user from the book's checkedOutBy map
      await FirebaseFirestore.instance
          .collection('books')
          .doc(bookId)
          .update({
        'checkedOutBy.$userId': FieldValue.delete(),
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Book checked in successfully!')),
      );
    } catch (e) {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error checking in book: $e')),
      );
    }
  }
  Future<void> _checkOutBook(String bookId, String userId) async {
    try {
      // Add the book to the user's checkedOut array
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({
        'checkedOut': FieldValue.arrayUnion([bookId]),
      });

      // Add the user to the book's checkedOutBy map
      await FirebaseFirestore.instance
          .collection('books')
          .doc(bookId)
          .update({
        'checkedOutBy.$userId': DateTime.now().toString(),
      });
      // Increment totalBooksCheckedOut
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({
        'totalBooksCheckedOut': FieldValue.increment(1),
      });

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Book checked out successfully!')),
      );
    } catch (e) {
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error checking out book: $e')),
      );
    }
  }

}