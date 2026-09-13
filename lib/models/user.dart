import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? profilePhotoUrl;
  final bool isOnline;
  final DateTime createdAt;
  final DateTime lastSeen;
  final List<String> blockedUsers;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.profilePhotoUrl,
    required this.isOnline,
    required this.createdAt,
    required this.lastSeen,
    required this.blockedUsers,
  });

  // Convert User to JSON for Firestore
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'phone': phone,
    'profilePhotoUrl': profilePhotoUrl,
    'isOnline': isOnline,
    'createdAt': createdAt,
    'lastSeen': lastSeen,
    'blockedUsers': blockedUsers,
  };

  // Create User from Firestore document
  factory User.fromJson(Map<String, dynamic> json, String docId) => User(
    id: docId,
    name: json['name'] ?? 'Unknown',
    email: json['email'] ?? '',
    phone: json['phone'],
    profilePhotoUrl: json['profilePhotoUrl'],
    isOnline: json['isOnline'] ?? false,
    createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    lastSeen: (json['lastSeen'] as Timestamp?)?.toDate() ?? DateTime.now(),
    blockedUsers: List<String>.from(json['blockedUsers'] ?? []),
  );

  // Create a copy with modified fields
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? profilePhotoUrl,
    bool? isOnline,
    DateTime? createdAt,
    DateTime? lastSeen,
    List<String>? blockedUsers,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      isOnline: isOnline ?? this.isOnline,
      createdAt: createdAt ?? this.createdAt,
      lastSeen: lastSeen ?? this.lastSeen,
      blockedUsers: blockedUsers ?? this.blockedUsers,
    );
  }

  @override
  String toString() => 'User(id: $id, name: $name, email: $email, isOnline: $isOnline)';

  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is User && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
