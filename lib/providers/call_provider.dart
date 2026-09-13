import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/call.dart';
import '../../models/call_history.dart';
import 'auth_provider.dart';

final firebaseProvider = Provider((ref) => FirebaseFirestore.instance);

// State notifier for current call
final currentCallProvider = StateNotifierProvider<CallNotifier, Call?>((ref) {
  return CallNotifier();
});

// Stream provider for incoming calls
final incomingCallStreamProvider = StreamProvider<Call?>((ref) {
  final currentUserId = ref.watch(currentUserIdProvider);
  if (currentUserId == null) return Stream.value(null);

  final firestore = ref.watch(firebaseProvider);
  return firestore
      .collection('calls')
      .where('receiverId', isEqualTo: currentUserId)
      .where('status', isEqualTo: 'CallStatus.ringing')
      .snapshots()
      .map((snapshot) {
        if (snapshot.docs.isEmpty) return null;
        // Return the first incoming call
        return _callFromFirestore(snapshot.docs.first);
      });
});

// Future provider for call history
final callHistoryProvider = FutureProvider<List<CallHistory>>((ref) async {
  final currentUserId = ref.watch(currentUserIdProvider);
  if (currentUserId == null) return [];

  final firestore = ref.watch(firebaseProvider);
  final snapshot = await firestore
      .collection('callHistory')
      .where('userId', isEqualTo: currentUserId)
      .orderBy('timestamp', descending: true)
      .limit(50)
      .get();

  return snapshot.docs
      .map((doc) => CallHistory.fromJson(doc.data(), doc.id))
      .toList();
});

// Stream provider for real-time call history
final callHistoryStreamProvider = StreamProvider<List<CallHistory>>((ref) {
  final currentUserId = ref.watch(currentUserIdProvider);
  if (currentUserId == null) return Stream.value([]);

  final firestore = ref.watch(firebaseProvider);
  return firestore
      .collection('callHistory')
      .where('userId', isEqualTo: currentUserId)
      .orderBy('timestamp', descending: true)
      .limit(50)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => CallHistory.fromJson(doc.data(), doc.id))
          .toList());
});

class CallNotifier extends StateNotifier<Call?> {
  CallNotifier() : super(null);

  void setCall(Call? call) {
    state = call;
  }

  void updateCallStatus(CallStatus status) {
    if (state == null) return;
    state = state!.copyWith(status: status);
  }

  void endCall() {
    state = null;
  }
}

// Helper function to convert Firestore document to Call model
Call _callFromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
  final data = doc.data()!;
  return Call(
    id: doc.id,
    callerId: data['callerId'] ?? '',
    callerName: data['callerName'] ?? 'Unknown',
    callerPhotoUrl: data['callerPhotoUrl'],
    receiverId: data['receiverId'] ?? '',
    receiverName: data['receiverName'] ?? 'Unknown',
    receiverPhotoUrl: data['receiverPhotoUrl'],
    callType: data['callType'].toString().contains('video') ? CallType.video : CallType.audio,
    status: _parseCallStatus(data['status']),
    initiatedAt: (data['initiatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    connectedAt: (data['connectedAt'] as Timestamp?)?.toDate(),
    endedAt: (data['endedAt'] as Timestamp?)?.toDate(),
    duration: data['duration'] != null ? Duration(seconds: data['duration']) : null,
    isIncoming: data['isIncoming'] ?? false,
  );
}

// Helper function to parse call status from string
CallStatus _parseCallStatus(String status) {
  switch (status) {
    case 'CallStatus.idle':
      return CallStatus.idle;
    case 'CallStatus.calling':
      return CallStatus.calling;
    case 'CallStatus.ringing':
      return CallStatus.ringing;
    case 'CallStatus.connected':
      return CallStatus.connected;
    case 'CallStatus.ended':
      return CallStatus.ended;
    case 'CallStatus.rejected':
      return CallStatus.rejected;
    case 'CallStatus.missed':
      return CallStatus.missed;
    case 'CallStatus.failed':
      return CallStatus.failed;
    default:
      return CallStatus.idle;
  }
}
