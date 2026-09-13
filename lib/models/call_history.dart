import 'package:cloud_firestore/cloud_firestore.dart';
import 'call.dart';

class CallHistory {
  final String id;
  final String userId;
  final String otherUserId;
  final String otherUserName;
  final String? otherUserPhotoUrl;
  final CallType callType;
  final bool isIncoming;
  final DateTime timestamp;
  final Duration duration;
  final bool isMissed;
  final bool isRejected;

  CallHistory({
    required this.id,
    required this.userId,
    required this.otherUserId,
    required this.otherUserName,
    this.otherUserPhotoUrl,
    required this.callType,
    required this.isIncoming,
    required this.timestamp,
    required this.duration,
    required this.isMissed,
    required this.isRejected,
  });

  // Get call status label
  String getStatusLabel() {
    if (isMissed) return 'Missed';
    if (isRejected) return 'Rejected';
    return isIncoming ? 'Received' : 'Outgoing';
  }

  // Get call direction label
  String getDirectionLabel() {
    return isIncoming ? 'Received' : 'Called';
  }

  // Format duration as MM:SS
  String formatDuration() {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  // Convert to JSON for Firestore
  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'otherUserId': otherUserId,
    'otherUserName': otherUserName,
    'otherUserPhotoUrl': otherUserPhotoUrl,
    'callType': callType.toString(),
    'isIncoming': isIncoming,
    'timestamp': timestamp,
    'durationSeconds': duration.inSeconds,
    'isMissed': isMissed,
    'isRejected': isRejected,
  };

  // Create from Firestore document
  factory CallHistory.fromJson(Map<String, dynamic> json, String docId) => CallHistory(
    id: docId,
    userId: json['userId'] ?? '',
    otherUserId: json['otherUserId'] ?? '',
    otherUserName: json['otherUserName'] ?? 'Unknown',
    otherUserPhotoUrl: json['otherUserPhotoUrl'],
    callType: json['callType'].toString().contains('video') ? CallType.video : CallType.audio,
    isIncoming: json['isIncoming'] ?? false,
    timestamp: (json['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    duration: Duration(seconds: json['durationSeconds'] ?? 0),
    isMissed: json['isMissed'] ?? false,
    isRejected: json['isRejected'] ?? false,
  );

  // Create a copy with modified fields
  CallHistory copyWith({
    String? id,
    String? userId,
    String? otherUserId,
    String? otherUserName,
    String? otherUserPhotoUrl,
    CallType? callType,
    bool? isIncoming,
    DateTime? timestamp,
    Duration? duration,
    bool? isMissed,
    bool? isRejected,
  }) {
    return CallHistory(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      otherUserId: otherUserId ?? this.otherUserId,
      otherUserName: otherUserName ?? this.otherUserName,
      otherUserPhotoUrl: otherUserPhotoUrl ?? this.otherUserPhotoUrl,
      callType: callType ?? this.callType,
      isIncoming: isIncoming ?? this.isIncoming,
      timestamp: timestamp ?? this.timestamp,
      duration: duration ?? this.duration,
      isMissed: isMissed ?? this.isMissed,
      isRejected: isRejected ?? this.isRejected,
    );
  }

  @override
  String toString() => 'CallHistory(id: $id, otherUserName: $otherUserName, callType: $callType)';
}
