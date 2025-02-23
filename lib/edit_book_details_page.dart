//   edit_book_details_page.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditBookDetailsPage extends StatefulWidget {
  final Map<String, dynamic> bookData;

  const EditBookDetailsPage({Key? key, required this.bookData})
      : super(key: key);

  @override
  _EditBookDetailsPageState createState() => _EditBookDetailsPageState();
}

class _EditBookDetailsPageState extends State<EditBookDetailsPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the text fields
  late TextEditingController _titleController;
  late TextEditingController _authorsController;
  late TextEditingController _publisherController;
  late TextEditingController _publishedDateController;
  late TextEditingController _descriptionController;
  late TextEditingController _pageCountController;
  late TextEditingController _categoriesController;
  late TextEditingController _averageRatingController;
  late TextEditingController _ratingsCountController;
  late TextEditingController _isbnController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _titleController = TextEditingController(text: widget.bookData['title']);
    _authorsController = TextEditingController(
        text: (widget.bookData['authors'] as List<dynamic>?)?.join(', ')?? '');
    _publisherController =
        TextEditingController(text: widget.bookData['publisher']);
    _publishedDateController =
        TextEditingController(text: widget.bookData['publishedDate']);
    _descriptionController =
        TextEditingController(text: widget.bookData['description']);
    _pageCountController =
        TextEditingController(text: widget.bookData['pageCount']?.toString());
    _categoriesController = TextEditingController(
        text: (widget.bookData['categories'] as List<dynamic>?)?.join(', ')??
            '');
    _averageRatingController = TextEditingController(
        text: widget.bookData['averageRating']?.toString());
    _ratingsCountController =
        TextEditingController(text: widget.bookData['ratingsCount']?.toString());
    _isbnController = TextEditingController(text: widget.bookData['isbn']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Book Details"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Title",
                ),
              ),
              const SizedBox(height: 10),

              // Authors
              TextFormField(
                controller: _authorsController,
                decoration: const InputDecoration(
                  labelText: "Authors",
                ),
              ),
              const SizedBox(height: 10),

              // Publisher
              TextFormField(
                controller: _publisherController,
                decoration: const InputDecoration(
                  labelText: "Publisher",
                ),
              ),
              const SizedBox(height: 10),

              // Published Date
              TextFormField(
                controller: _publishedDateController,
                decoration: const InputDecoration(
                  labelText: "Published Date",
                ),
              ),
              const SizedBox(height: 10),

              // Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: "Description",
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 10),

              // Page Count
              TextFormField(
                controller: _pageCountController,
                decoration: const InputDecoration(
                  labelText: "Page Count",
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),

              // Categories
              TextFormField(
                controller: _categoriesController,
                decoration: const InputDecoration(
                  labelText: "Categories",
                ),
              ),
              const SizedBox(height: 10),

              // Average Rating
              TextFormField(
                controller: _averageRatingController,
                decoration: const InputDecoration(
                  labelText: "Average Rating",
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),

              // Ratings Count
              TextFormField(
                controller: _ratingsCountController,
                decoration: const InputDecoration(
                  labelText: "Ratings Count",
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),

              // ISBN
              TextFormField(
                controller: _isbnController,
                decoration: const InputDecoration(
                  labelText: "ISBN",
                ),
              ),
              const SizedBox(height: 20),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Go back to EditInventoryPage
                    },
                    child: const Text("CANCEL"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _saveChanges(context);
                      }
                    },
                    child: const Text("SUBMIT"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveChanges(BuildContext context) async {
    try {
      // Update book data in Firestore
      await FirebaseFirestore.instance
          .collection('books')
          .doc(widget.bookData['isbn'])
          .update({
        'title': _titleController.text,
        'authors': _authorsController.text.split(', '),
        'publisher': _publisherController.text,
        'publishedDate': _publishedDateController.text,
        'description': _descriptionController.text,
        'pageCount': int.tryParse(_pageCountController.text),
        'categories': _categoriesController.text.split(', '),
        'averageRating': double.tryParse(_averageRatingController.text),
        'ratingsCount': int.tryParse(_ratingsCountController.text),
        'isbn': _isbnController.text,
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
            Text('Information for ${_titleController.text} updated!')),
      );

      // Navigate back to EditInventoryPage
      Navigator.pop(context);
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating book: $e')),
      );
    }
  }
}