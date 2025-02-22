//  edit_profile.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}): super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the text fields
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _birthdayController;
  late TextEditingController _streetController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _zipCodeController;
  late TextEditingController _favoriteBookController;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user!= null) {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        _fullNameController = TextEditingController(text: userData['fullName']);
        _emailController = TextEditingController(text: userData['email']);
        _passwordController = TextEditingController(text: userData['password']);
        _birthdayController = TextEditingController(text: userData['birthday']);
        _streetController = TextEditingController(text: userData['address']);
        _cityController = TextEditingController(text: userData['city']);
        _stateController = TextEditingController(text: userData['state']);
        _zipCodeController = TextEditingController(text: userData['zipCode']);
        _favoriteBookController =
            TextEditingController(text: userData['favoriteBook']);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Full Name (non-editable)
              TextFormField(
                controller: _fullNameController,
                enabled: false, // Make it non-editable
                decoration: const InputDecoration(
                  labelText: "Full Name",
                ),
                style: const TextStyle(color: Colors.grey), // Lighter color
              ),
              const SizedBox(height: 10),

              // Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Password
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Birthday
              TextFormField(
                controller: _birthdayController,
                decoration: const InputDecoration(
                  labelText: "Birthday",
                ),
              ),
              const SizedBox(height: 10),

              // Street Address
              TextFormField(
                controller: _streetController,
                decoration: const InputDecoration(
                  labelText: "Street Address",
                ),
              ),
              const SizedBox(height: 10),

              // City
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: "City",
                ),
              ),
              const SizedBox(height: 10),

              // State
              TextFormField(
                controller: _stateController,
                decoration: const InputDecoration(
                  labelText: "State",
                ),
              ),
              const SizedBox(height: 10),

              // Zip Code
              TextFormField(
                controller: _zipCodeController,
                decoration: const InputDecoration(
                  labelText: "Zip Code",
                ),
              ),
              const SizedBox(height: 10),

              // Favorite Book
              TextFormField(
                controller: _favoriteBookController,
                decoration: const InputDecoration(
                  labelText: "Favorite Book",
                ),
              ),
              const SizedBox(height: 20),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Handle Cancel
                      Navigator.pop(context); // Go back to ProfilePage
                    },
                    child: const Text("CANCEL"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _saveChanges(context);
                      }
                    },
                    child: const Text("SAVE"),
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
      final user = FirebaseAuth.instance.currentUser;
      if (user!= null) {
        // Check if username or email already exists (if changed)
        //... (similar to how you did it in _registerUser)

        // Update user data in Firestore
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'email': _emailController.text,
          'password': _passwordController.text,
          'birthday': _birthdayController.text,
          'address': _streetController.text,
          'city': _cityController.text,
          'state': _stateController.text,
          'zipCode': _zipCodeController.text,
          'favoriteBook': _favoriteBookController.text,
          //... other fields
        });

        // Navigate back to ProfilePage
        Navigator.pop(context);
      }
    } catch (e) {
      // Show error message
    }
  }
}