import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<User?> signInWithEmailPassword(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  Future<User?> signUpWithEmailPassword(
      String email, String password, String username) async {
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    await firebaseFirestore
        .collection('users')
        .doc(userCredential.user!.uid)
        .set({
      'name': username,
      'email': userCredential.user!.email,
      'uid': userCredential.user!.uid,
    });
    return userCredential.user;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String?> getUserName(User user) async {
    final doc = await firebaseFirestore.collection('users').doc(user.uid).get();
    if (doc.exists) {
      return doc.data()?['name'];
    }
    return null;
  }

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
}
