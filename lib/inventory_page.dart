//  inventory_page.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({Key? key}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      appBar: AppBar(
        title: const Text("Full Inventory"),

      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('books').snapshots(),

        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final books = snapshot.data!.docs;

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // Number of columns in the grid
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index].data() as Map<String, dynamic>;
              final imageLinks = book['imageLinks'] as Map<String, dynamic>?;
              final imageUrl = imageLinks?['thumbnail'] as String?;
              return Card(
                  clipBehavior: Clip.antiAlias,
                  child: Expanded( // Wrap the Column with Expanded
                  child: Column(
                  children: [
                  SizedBox(
                  height: 60,
                  width: 60,
                  child: imageUrl!= null
                  ? Image.network(imageUrl, width: 60, height: 60, fit: BoxFit.cover)
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
              ));
            },
          );
        },
      ),
    );
  }
}