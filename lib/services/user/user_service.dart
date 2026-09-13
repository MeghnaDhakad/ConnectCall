import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user.dart';

class UserService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all users except current user
  Future<List<User>> getAllUsers(String currentUserId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('id', isNotEqualTo: currentUserId)
          .get();

      return snapshot.docs
          .map((doc) => User.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }

  // Get users stream for real-time updates
  Stream<List<User>> getUsersStream(String currentUserId) {
    return _firestore
        .collection('users')
        .where('id', isNotEqualTo: currentUserId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => User.fromJson(doc.data(), doc.id))
            .toList());
  }

  // Search users by name or email
  Future<List<User>> searchUsers(String query, String currentUserId) async {
    try {
      if (query.isEmpty) {
        return getAllUsers(currentUserId);
      }

      final snapshot = await _firestore.collection('users').get();

      return snapshot.docs
          .where((doc) {
            final user = User.fromJson(doc.data(), doc.id);
            return user.id != currentUserId &&
                (user.name.toLowerCase().contains(query.toLowerCase()) ||
                    user.email.toLowerCase().contains(query.toLowerCase()));
          })
          .map((doc) => User.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Search failed: $e');
    }
  }

  // Get user by ID
  Future<User?> getUserById(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return User.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch user: $e');
    }
  }

  // Get user by ID stream
  Stream<User?> getUserStream(String userId) {
    return _firestore.collection('users').doc(userId).snapshots().map((doc) {
      if (doc.exists) {
        return User.fromJson(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    });
  }

  // Update user profile
  Future<User> updateUserProfile({
    required String userId,
    required String name,
    String? phone,
    String? profilePhotoUrl,
  }) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'name': name,
        if (phone != null) 'phone': phone,
        if (profilePhotoUrl != null) 'profilePhotoUrl': profilePhotoUrl,
      });

      final user = await getUserById(userId);
      if (user == null) throw Exception('User not found');
      return user;
    } catch (e) {
      throw Exception('Failed to update profile: $e');
    }
  }

  // Block a user
  Future<void> blockUser(String userId, String blockedUserId) async {
    try {
      final userRef = _firestore.collection('users').doc(userId);
      await userRef.update({
        'blockedUsers': FieldValue.arrayUnion([blockedUserId]),
      });
    } catch (e) {
      throw Exception('Failed to block user: $e');
    }
  }

  // Unblock a user
  Future<void> unblockUser(String userId, String blockedUserId) async {
    try {
      final userRef = _firestore.collection('users').doc(userId);
      await userRef.update({
        'blockedUsers': FieldValue.arrayRemove([blockedUserId]),
      });
    } catch (e) {
      throw Exception('Failed to unblock user: $e');
    }
  }

  // Check if user is blocked
  Future<bool> isUserBlocked(String userId, String targetUserId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final blockedUsers = List<String>.from(userDoc['blockedUsers'] ?? []);
        return blockedUsers.contains(targetUserId);
      }
      return false;
    } catch (e) {
      throw Exception('Failed to check blocked status: $e');
    }
  }

  // Get online contacts
  Future<List<User>> getOnlineContacts(String currentUserId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('id', isNotEqualTo: currentUserId)
          .where('isOnline', isEqualTo: true)
          .get();

      return snapshot.docs
          .map((doc) => User.fromJson(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch online contacts: $e');
    }
  }
}
