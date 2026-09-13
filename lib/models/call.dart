enum CallType { audio, video }

enum CallStatus { idle, calling, ringing, connected, ended, rejected, missed, failed }

class Call {
  final String id;
  final String callerId;
  final String callerName;
  final String? callerPhotoUrl;
  final String receiverId;
  final String receiverName;
  final String? receiverPhotoUrl;
  final CallType callType;
  final CallStatus status;
  final DateTime initiatedAt;
  final DateTime? connectedAt;
  final DateTime? endedAt;
  final Duration? duration;
  final bool isIncoming;

  Call({
    required this.id,
    required this.callerId,
    required this.callerName,
    this.callerPhotoUrl,
    required this.receiverId,
    required this.receiverName,
    this.receiverPhotoUrl,
    required this.callType,
    required this.status,
    required this.initiatedAt,
    this.connectedAt,
    this.endedAt,
    this.duration,
    required this.isIncoming,
  });

  // Get the other party's name based on call direction
  String getOtherPartyName(String currentUserId) {
    return currentUserId == callerId ? receiverName : callerName;
  }

  // Get the other party's photo URL based on call direction
  String? getOtherPartyPhoto(String currentUserId) {
    return currentUserId == callerId ? receiverPhotoUrl : callerPhotoUrl;
  }

  // Convert to JSON for Firestore
  Map<String, dynamic> toJson() => {
    'id': id,
    'callerId': callerId,
    'callerName': callerName,
    'callerPhotoUrl': callerPhotoUrl,
    'receiverId': receiverId,
    'receiverName': receiverName,
    'receiverPhotoUrl': receiverPhotoUrl,
    'callType': callType.toString(),
    'status': status.toString(),
    'initiatedAt': initiatedAt,
    'connectedAt': connectedAt,
    'endedAt': endedAt,
    'duration': duration?.inSeconds,
    'isIncoming': isIncoming,
  };

  // Create a copy with modified fields
  Call copyWith({
    String? id,
    String? callerId,
    String? callerName,
    String? callerPhotoUrl,
    String? receiverId,
    String? receiverName,
    String? receiverPhotoUrl,
    CallType? callType,
    CallStatus? status,
    DateTime? initiatedAt,
    DateTime? connectedAt,
    DateTime? endedAt,
    Duration? duration,
    bool? isIncoming,
  }) {
    return Call(
      id: id ?? this.id,
      callerId: callerId ?? this.callerId,
      callerName: callerName ?? this.callerName,
      callerPhotoUrl: callerPhotoUrl ?? this.callerPhotoUrl,
      receiverId: receiverId ?? this.receiverId,
      receiverName: receiverName ?? this.receiverName,
      receiverPhotoUrl: receiverPhotoUrl ?? this.receiverPhotoUrl,
      callType: callType ?? this.callType,
      status: status ?? this.status,
      initiatedAt: initiatedAt ?? this.initiatedAt,
      connectedAt: connectedAt ?? this.connectedAt,
      endedAt: endedAt ?? this.endedAt,
      duration: duration ?? this.duration,
      isIncoming: isIncoming ?? this.isIncoming,
    );
  }

  @override
  String toString() => 'Call(id: $id, status: $status, callType: $callType)';
}
