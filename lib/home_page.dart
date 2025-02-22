//home_page.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'login_page.dart'; // Import your login page
import 'package:provider/provider.dart';
import 'auth_provider.dart'; // Import the AuthProvider class
import 'profile_page.dart'; // Import the ProfilePage
import 'edit_profile_page.dart'; // Import the EditProfilePage
import 'admin_screen.dart'; // Import the AdminScreen
import 'inventory_page.dart'; // Import the InventoryPage
import  'book_details_page.dart'; // Import the BookDetailsPage

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppAuthProvider>( // Use Consumer to listen for login state changes
        builder: (context, authProvider, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("LPCC Library"),
              actions: [

                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (authProvider.isLoggedIn) {
                      if (value == 'Profile') {
                        // Navigate to ProfilePage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfilePage()),
                        );
                      } else if (value == 'Edit Profile') {
                        // Navigate to EditProfilePage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EditProfilePage()),
                        );
                      } else if (value == 'Logout') {
                        // Handle logout logic
                        authProvider.setLoggedIn(
                            false); // Update login state using provider
                      }
                    } else {
                      if (value == 'Login') {
                        Navigator.push(
                          // Navigate to Login Page
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                        );
                      }
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuEntry<String>>[
                      if (authProvider.isLoggedIn)
                        const PopupMenuItem<String>(
                          value: 'Profile',
                          child: Text('Profile'),
                        ),
                      if (authProvider.isLoggedIn)
                        const PopupMenuItem<String>(
                          value: 'Edit Profile',
                          child: Text('Edit Profile'),
                        ),
                      if (authProvider.isLoggedIn)
                        const PopupMenuItem<String>(
                          value: 'Logout',
                          child: Text('Logout'),
                        ),
                      if (!authProvider.isLoggedIn)
                        const PopupMenuItem<String>(
                          value: 'Login',
                          child: Text('Login'),
                        ),
                    ];
                  },
                  child: const CircleAvatar(
                    // The avatar is the child of the PopupMenuButton
                    backgroundImage: NetworkImage(
                      "https://www.seekpng.com/png/full/115-1150053_avatar-png-transparent-png-royalty-free-default-avatar.png",
                    ),
                  ),
                ), // End of PopupMenuButton
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    // Handle menu action
                    _showMenu(context, authProvider);
                  },
                ),
              ],
            ),
            body: ListView(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),

                // Advanced Search Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextButton(
                    onPressed: () {
                      // Handle advanced search action
                    },
                    child: const Text("Advanced Search"),
                  ),
                ),

                // Library Logo and Motto
                Center(
                  child: Column(
                    children: [
                    Image.asset(
                    'assets/images/widelogo.png',
                        height: 100,
                      ),
                      Text("Read, Learn, Live", style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),

                // Newly Added Section
                const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                "Newly Added",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ),
                SizedBox(
                height: 200,
                child: _buildNewlyAddedBooks(),

                ),

                // Recently Checked-Out Section
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Recently Checked-Out",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
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

                // View Full Inventory Button
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to InventoryPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const InventoryPage()),
                      );
                    },
                    child: const Text("View Full Inventory"),
                  ),
                ),
              ],
            ),
          );
        });
        }
  void _showMenu(BuildContext context, AppAuthProvider authProvider) {
    showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(1000, 80, 0, 0),
      items: [
        if (authProvider.isAdmin!= null && authProvider.isAdmin)
          const PopupMenuItem<String>(
            value: 'Admin Screen',
            child: Text('Admin Screen'),
          ),
        const PopupMenuItem<String>( // Add a default menu item
          value: 'Settings',
          child: Text('Settings'),
        ),
        //... (other menu items)
      ],

    ).then((value) {
      if (value == 'Admin Screen') {
        // Navigate to AdminScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AdminScreen()),
        );
      }
      //... (handle other menu items)
    });
  }
}
Widget _buildNewlyAddedBooks() {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('books')
        .orderBy('publishedDate', descending: true)
        .limit(3)
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      final books = snapshot.data!.docs;


      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index].data() as Map<String, dynamic>;
          final imageLinks = book['imageLinks'] as Map<String, dynamic>?;
          final imageUrl = imageLinks?['thumbnail'] as String?;
          return SizedBox(
              width: 130,
              // height: 50, // Remove fixed height
              child: GestureDetector( // Wrap the Card with GestureDetector
              onTap: () {
            // Navigate to BookDetailsPage
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookDetailsPage(bookData: book),
              ),
            );
          },
          child: Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
          children: [
          SizedBox(
          height: 150,
          width: 130, // Set a fixed width for each book item
          child: imageUrl!= null
          ? Image.network(
          imageUrl,
          width: 130,
          height: 150,
          fit: BoxFit.cover,
          )
              : const Icon(Icons.book),
          ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      book['title'],
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
          ],
          ),
          ),
              ),
          );
        },
      );
    },
  );
}