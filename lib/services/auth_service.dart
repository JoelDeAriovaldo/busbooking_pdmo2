import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart' as AppUser;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register with email and password
  Future<User?> registerWithEmailAndPassword(
      String email, String password, String name, String phoneNumber) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      // Create a new document for the user with the uid
      await _firestore.collection('users').doc(user?.uid).set({
        'id': user?.uid,
        'name': name,
        'phoneNumber': phoneNumber,
        'email': email,
        'password': password,
        'travelHistory': [],
        'seatPreference': '',
      });

      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Get user data
  Future<AppUser.User?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      return AppUser.User.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
