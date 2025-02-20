//register_page.dart

import 'package:flutter/material.dart';
import 'home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  bool _agree1 = false;
  bool _agree2 = false;

  // Add TextEditingControllers
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  //... (add controllers for other fields as needed)

  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    //... (dispose of other controllers)
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Full Name
              TextFormField(
                controller: _fullNameController, // Assign the controller
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Username
              TextFormField(
                controller: _usernameController, // Assign the controller
                decoration: const InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Email
              TextFormField(
                controller: _emailController, // Assign the controller
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
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
                controller: _passwordController, // Assign the controller
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Birthday
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Birthday (Month and Day)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              // Street Address
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Street Address",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              // City
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "City",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              // State
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "State",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              // Zip Code
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Zip Code",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              // Favorite Book
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Favorite Book",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Checkboxes
              CheckboxListTile(
                title: const Text(
                    "I agree to take care of any checked-out books, until I return them."),
                value: _agree1,
                onChanged: (value) {
                  setState(() {
                    _agree1 = value!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              CheckboxListTile(
                title: const Text(
                    "I agree to replace any books that were damaged while checked-out by me."),
                value: _agree2,
                onChanged: (value) {
                  setState(() {
                    _agree2 = value!;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 20),

              // Submit Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() &&
                      _agree1 &&
                      _agree2) {
                    // Process registration
                    _registerUser(context); // Call the registration function
                  } else {
                    // Show error message
                  }
                },
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Function to handle registration logic
  Future<void> _registerUser(BuildContext context) async {
    try {
      // 1. Gather user data from the form fields
      final fullName = _fullNameController.text;
      final username = _usernameController.text;
      final email = _emailController.text;
      final password = _passwordController.text;

      // 2. Check if username or email already exists
      final usernameQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .get();
      if (usernameQuery.docs.isNotEmpty) {
        // Show error message: Username already exists
        return;
      }

      final emailQuery = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      if (emailQuery.docs.isNotEmpty) {
        // Show error message: Email already exists
        return;
      }

      // 3. Create user with email and password
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // 4. Get the next available library card number
      final lastCardNumberQuery = await FirebaseFirestore.instance
          .collection('library_card_numbers')
          .doc('last_number')
          .get();
      int lastCardNumber = lastCardNumberQuery.data()?['number'] ?? 0;
      int newCardNumber = lastCardNumber + 1;

      // 5. Update the last library card number
      await FirebaseFirestore.instance
          .collection('library_card_numbers')
          .doc('last_number')
          .set({'number': newCardNumber});

      // 6. Store user data in Firestore
      final user = credential.user;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'fullName': fullName,
          'username': username,
          'libraryCardNumber': newCardNumber,
          //... (store other data)
        });
      }

      // 7. Navigate to the home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      print("Firebase exception: ${e.code}"); // Added print statement
      if (e.code == 'weak-password') {
        // Show error message: Weak password
      } else if (e.code == 'email-already-in-use') {
        // Show error message: Email already in use
      } else {
        // Show generic error message
      }
    } catch (e) {
      print("Generic exception: $e"); // Added print statement
      // Show generic error message
    }
  }
}