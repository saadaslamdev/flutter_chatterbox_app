import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:globatchat_app/models/user_model.dart';
import '../services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _userModel;
  String? _errorMessage;

  UserModel? get userModel => _userModel;
  String? get errorMessage => _errorMessage;

  AuthViewModel() {
    listenToAuthState();
  }

  Future<(String? error, User? user)> signIn(
      String email, String password) async {
    try {
      _errorMessage = null;
      firebase_auth.User? firebaseUser =
          await _authService.signInWithEmailPassword(email, password);
      await fetchUserData(firebaseUser!);
      notifyListeners();
      return (null, firebaseUser);
    } on firebase_auth.FirebaseAuthException catch (e) {
      _errorMessage = _handleAuthException(e);
      notifyListeners();
      return (_errorMessage, null);
    }
  }

  Future<(String? error, User? user)> signUp(String email, String password,
      String username, String phoneNumber) async {
    try {
      _errorMessage = null;
      await _authService.signUpWithEmailPassword(
          email, password, username, phoneNumber);
      await _authService.signOut();
      notifyListeners();
      return (null, null);
    } on firebase_auth.FirebaseAuthException catch (e) {
      _errorMessage = _handleAuthException(e);
      notifyListeners();
      return (_errorMessage, null);
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _userModel = null;
    notifyListeners();
  }

  void listenToAuthState() {
    _authService.authStateChanges.listen((firebaseUser) {
      if (firebaseUser != null) {
        fetchUserData(firebaseUser);
      } else {
        _userModel = null;
        notifyListeners();
      }
    });
  }

  Future<void> fetchUserData(User user) async {
    var data = await _authService.fetchUserData(user);
    if (data != null) {
      _userModel = UserModel.fromMap(data, user);
    } else {
      _userModel = null;
    }
    notifyListeners();
  }

  Future<String?> setUserModel(Map<String, dynamic> userModel) async {
    try {
      final currentData = _userModel!.toMap();
      final updatedData = {...currentData, ...userModel};
      await _authService.updateUserData(_userModel!.user!, updatedData);
      _userModel = UserModel.fromMap(updatedData);
      notifyListeners();

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  String _handleAuthException(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'user-disabled':
        return 'The user account has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      case 'operation-not-allowed':
        return 'Operation not allowed.';
      case 'email-already-in-use':
        return 'The email address is already in use.';
      case 'weak-password':
        return 'The password is too weak.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
