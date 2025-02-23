//  auth_provider.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppAuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  bool _isAdmin = false;

  bool get isLoggedIn => _isLoggedIn;
  bool get isAdmin => _isAdmin;

  AppAuthProvider() {
    _loadLoginState(); // Load login state on initialization
  }

  void setLoggedIn(bool value) {
    _isLoggedIn = value;
    _saveLoginState(); // Save login state
    _checkAdminStatus();
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
      setAdmin(userData['isAdmin']?? false);
    } else {
      setAdmin(false);
    }
  }

  Future<void> _loadLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    setLoggedIn(prefs.getBool('isLoggedIn')?? false);
  }

  Future<void> _saveLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', _isLoggedIn);
  }
}