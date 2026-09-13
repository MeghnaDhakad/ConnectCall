import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user.dart';

class AuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user stream
  Stream<User?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      
      try {
        final userDoc = await _firestore.collection('users').doc(firebaseUser.uid).get();
        if (userDoc.exists) {
          return User.fromJson(userDoc.data() as Map<String, dynamic>, firebaseUser.uid);
        }
      } catch (e) {
        print('Error fetching user: $e');
      }
      return null;
    });
  }

  // Get current user ID
  String? get currentUserId => _firebaseAuth.currentUser?.uid;

  // Get current Firebase user
  User? get currentUser => _firebaseAuth.currentUser as User?;

  // Register with email and password
  Future<User> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) throw Exception('User creation failed');

      // Create user document in Firestore
      final user = User(
        id: firebaseUser.uid,
        name: name,
        email: email,
        phone: null,
        profilePhotoUrl: null,
        isOnline: true,
        createdAt: DateTime.now(),
        lastSeen: DateTime.now(),
        blockedUsers: [],
      );

      await _firestore.collection('users').doc(firebaseUser.uid).set(user.toJson());

      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  // Login with email and password
  Future<User> login({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) throw Exception('Login failed');

      // Update online status
      await _firestore.collection('users').doc(firebaseUser.uid).update({
        'isOnline': true,
        'lastSeen': DateTime.now(),
      });

      final userDoc = await _firestore.collection('users').doc(firebaseUser.uid).get();
      return User.fromJson(userDoc.data() as Map<String, dynamic>, firebaseUser.uid);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      final userId = currentUserId;
      if (userId != null) {
        // Update offline status
        await _firestore.collection('users').doc(userId).update({
          'isOnline': false,
          'lastSeen': DateTime.now(),
        });
      }
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  // Update user online status
  Future<void> updateOnlineStatus(bool isOnline) async {
    try {
      final userId = currentUserId;
      if (userId != null) {
        await _firestore.collection('users').doc(userId).update({
          'isOnline': isOnline,
          'lastSeen': DateTime.now(),
        });
      }
    } catch (e) {
      print('Error updating online status: $e');
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  // Handle Firebase auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email.';
      case 'wrong-password':
        return 'Wrong password provided for that user.';
      case 'email-already-in-use':
        return 'The account already exists for that email.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'invalid-email':
        return 'The email address is not valid.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
