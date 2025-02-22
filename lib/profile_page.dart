//  profile_page.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LPCC Library"),
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
                              Text('Member Since: ${userData['memberSince']?? 'Unknown'}'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Library Card Number:',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                          child: Text(
                            userData['libraryCardNumber'].toString(),
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
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
                              Text(userData['overdueLate'].toString()),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Saved Books:'),
                              Text(userData['savedBooks'].toString()),
                            ],
                          ),
                        ),
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
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 3, // Replace with actual number of books
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.network(
                                  "https://m.media-amazon.com/images/I/51wS8m9c82L._SX322_BO1,2048,1536,1536_.jpg",
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        ),
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
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 3, // Replace with actual number of badges
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.network(
                                  "https://m.media-amazon.com/images/I/51wS8m9c82L._SX322_BO1,2048,1536,1536_.jpg",
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        ),
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
}