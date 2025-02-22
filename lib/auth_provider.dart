//  auth_provider.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppAuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isAdmin = false;

  bool get isLoggedIn => _isLoggedIn;

  bool get isAdmin => _isAdmin;

  void setLoggedIn(bool value) {
    _isLoggedIn = value;
    _checkAdminStatus(); // Check admin status after login
    notifyListeners();
  }

  void setAdmin(bool value) {
    _isAdmin = value;
    notifyListeners();
  }

  Future<void> _checkAdminStatus() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user!= null) {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setAdmin(userData['isAdmin']?? false); // Update isAdmin based on Firestore value
    } else {
      setAdmin(false); // User not logged in, so not an admin
    }
  }
}