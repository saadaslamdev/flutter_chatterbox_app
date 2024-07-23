import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Future<User?> signInWithEmailPassword(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  Future<User?> signUpWithEmailPassword(String email, String password,
      String username, String phoneNumber) async {
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    var data = {
      'name': username,
      'email': userCredential.user!.email,
      'phoneNumber': phoneNumber,
      'uid': userCredential.user!.uid,
    };

    await updateUserData(userCredential.user!, data);
    return userCredential.user;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<Map<String, dynamic>?> fetchUserData(User user) async {
    final doc = await _firebaseFirestore.collection('users').doc(user.uid).get();
    if (doc.exists) {
      return doc.data()!;
    }
    return null;
  }

  Future<void> updateUserData(User user, Map<String, dynamic> data) async {
    await _firebaseFirestore
        .collection('users')
        .doc(user.uid)
        .set(data, SetOptions(merge: true));
  }

  Future<void> uploadImageToFirestore(
      String userId, Uint8List imageBytes) async {
    final storageRef =
        firebaseStorage.ref().child('users/$userId/profilePicture.jpg');

    await storageRef.putData(imageBytes);
  }

  Future<String> getDownloadURL(String userId) async {
    final storageRef =
        firebaseStorage.ref().child('users/$userId/profilePicture.jpg');

    String downloadURL = await storageRef.getDownloadURL();
    print('downloadURL $downloadURL');
    return downloadURL;
  }

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
}
