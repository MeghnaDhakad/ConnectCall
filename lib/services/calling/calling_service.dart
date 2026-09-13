import '../../models/call.dart';

abstract class CallingService {
  // Initialize the calling service
  Future<void> initialize();

  // Start an audio call
  Future<void> startAudioCall({
    required String callerId,
    required String receiverId,
  });

  // Start a video call
  Future<void> startVideoCall({
    required String callerId,
    required String receiverId,
  });

  // Accept an incoming call
  Future<void> acceptCall(String callId);

  // Reject/decline an incoming call
  Future<void> rejectCall(String callId);

  // End an ongoing call
  Future<void> endCall(String callId);

  // Mute/unmute microphone
  Future<void> muteAudio(bool mute);

  // Enable/disable speaker
  Future<void> enableSpeaker(bool enable);

  // Enable/disable camera
  Future<void> enableCamera(bool enable);

  // Switch camera (front/rear)
  Future<void> switchCamera();

  // Get call stream for state updates
  Stream<Call> getCallStream();

  // Get incoming call stream
  Stream<Call> getIncomingCallStream();

  // Dispose resources
  Future<void> dispose();
}
