//login_page.dart

import 'package:flutter/material.dart';
import 'register_page.dart'; // Import your register page

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Center(
        child: SingleChildScrollView( // Added for scrollability
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              const SizedBox(height: 20),

              // Email Input
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),

              // Password Input
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Login Button
              ElevatedButton(
                onPressed: () {
                  // Handle login action
                },
                child: const Text("Login"),
              ),
              const SizedBox(height: 10),

              // Register Button
              TextButton(
                onPressed: () {
                  Navigator.push( // Navigate to RegisterPage
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
    );
  }
}