//home_page.dart

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LPCC Library"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Handle search action
            },
          ),
          IconButton(
            icon: const CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://www.seekpng.com/png/full/115-1150053_avatar-png-transparent-png-royalty-free-default-avatar.png"),
            ),
            onPressed: () {
              // Handle user profile action
            },
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Handle menu action
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
              children: const [
                Image(
                  image: NetworkImage(
                      "https://upload.wikimedia.org/wikipedia/commons/thumb/f/ff/Books-3.svg/1024px-Books-3.svg.png"),
                  height: 100,
                ),
                Text(
                  "Read, Learn, Live",
                  style: TextStyle(fontSize: 20),
                ),
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
                // Handle view full inventory action
              },
              child: const Text("View Full Inventory"),
            ),
          ),
        ],
      ),
    );
  }
}