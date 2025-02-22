//login_page.dart

import 'package:flutter/material.dart';
import 'home_page.dart';
import 'register_page.dart'; // Import your register page
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'auth_provider.dart'; // Import the AuthProvider class

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F2F1), // Set light green background color
      appBar: AppBar(
        title: const Text("Login"),
    ),
    body: Center(
    child: SingleChildScrollView(
      reverse: true,
    padding: const EdgeInsets.all(20.0),
    child: Form(
    key: _formKey,
    child: Column(

    mainAxisAlignment: MainAxisAlignment.center,
    children: [

      // Library Logo and Motto
      Center(
        child: Column(

          children: [
            Image.asset(
              'assets/images/widelogo.png',
              height: 100,
            ),
            Text(
              "Where the imagination grows!",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),

      // Email Input
      TextFormField(
        controller: _emailController,
        decoration: const InputDecoration(
          labelText: "Email",
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your email';
          }
          return null;
        },
      ),
      const SizedBox(height: 10),

      // Password Input
      TextFormField(
        controller: _passwordController,
        obscureText: true,
        decoration: const InputDecoration(
          labelText: "Password",
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          }
          return null;
        },
      ),
      const SizedBox(height: 20),

      // Login Button
      ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _loginUser(context);
          }
        },
        child: const Text("Login"),
      ),
      const SizedBox(height: 10),

      // Register Button
      TextButton(
        onPressed: () {
          Navigator.push(
            // Navigate to RegisterPage
            context,
            MaterialPageRoute(
                builder: (context) => const RegisterPage()),
          );
        },
        child: const Text("Register"),
      ),
    ],
    ),
    ),
    ),
    ),
    );
  }

  Future<void> _loginUser(BuildContext context) async {
    try {
      final email = _emailController.text;
      final password = _passwordController.text;

      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // Update login state
      Provider.of<AppAuthProvider>(context, listen: false).setLoggedIn(true);

      // Navigate to home page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        // Show error message: User not found
      } else if (e.code == 'wrong-password') {
        // Show error message: Wrong password
      } else {
        // Show generic error message
      }
    } catch (e) {
      // Show generic error message
    }
  }
}