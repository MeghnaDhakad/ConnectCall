import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import '../../models/call.dart';
import '../../core/constants/app_config.dart';
import 'calling_service.dart';

class AgoraCallingService extends CallingService {
  late RtcEngine _engine;
  final _callStreamController = StreamController<Call>.broadcast();
  final _incomingCallStreamController = StreamController<Call>.broadcast();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isMuted = false;
  bool _isCameraEnabled = true;
  bool _isSpeakerEnabled = true;

  @override
  Future<void> initialize() async {
    try {
      _engine = createAgoraRtcEngine();
      await _engine.initialize(
        RtcEngineContext(
          appId: AppConfig.agoraAppId,
          channelProfile: ChannelProfileType.channelProfileCommunication,
        ),
      );

      // Set up event handlers
      _engine.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            print('✓ Joined channel: ${connection.channelId}');
            _callStreamController.add(
              Call(
                id: connection.channelId,
                callerId: '',
                callerName: '',
                receiverId: '',
                receiverName: '',
                callType: CallType.audio,
                status: CallStatus.connected,
                initiatedAt: DateTime.now(),
                isIncoming: false,
              ),
            );
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            print('✓ Remote user joined: $remoteUid');
          },
          onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
            print('✗ Remote user offline: $remoteUid');
            _callStreamController.add(
              Call(
                id: connection.channelId,
                callerId: '',
                callerName: '',
                receiverId: '',
                receiverName: '',
                callType: CallType.audio,
                status: CallStatus.ended,
                initiatedAt: DateTime.now(),
                isIncoming: false,
              ),
            );
          },
          onError: (RtcErrorType errorType, String msg) {
            print('✗ Agora Error: $errorType - $msg');
          },
        ),
      );

      await _engine.enableAudio();
      await _engine.enableVideo();
      print('✓ Agora initialized successfully');
    } catch (e) {
      print('✗ Agora initialization failed: $e');
      rethrow;
    }
  }

  @override
  Future<void> startAudioCall({
    required String callerId,
    required String receiverId,
  }) async {
    try {
      final channelName = _generateChannelName(callerId, receiverId);
      
      // Disable video for audio call
      await _engine.disableVideo();
      
      await _engine.joinChannel(
        token: AppConfig.agoraToken.isEmpty ? null : AppConfig.agoraToken,
        channelId: channelName,
        uid: callerId.hashCode % 4294967296,
        options: const RtcChannelMediaOptions(
          autoSubscribeAudio: true,
          autoSubscribeVideo: false,
          publishMicrophoneTrack: true,
        ),
      );

      print('✓ Audio call started: $channelName');
    } catch (e) {
      print('✗ Failed to start audio call: $e');
      rethrow;
    }
  }

  @override
  Future<void> startVideoCall({
    required String callerId,
    required String receiverId,
  }) async {
    try {
      final channelName = _generateChannelName(callerId, receiverId);
      
      // Enable video for video call
      await _engine.enableVideo();
      await _engine.setVideoEncoderConfiguration(
        const VideoEncoderConfiguration(
          dimensions: VideoDimensions(width: 640, height: 480),
          frameRate: 15,
          bitrate: 1024,
        ),
      );

      await _engine.joinChannel(
        token: AppConfig.agoraToken.isEmpty ? null : AppConfig.agoraToken,
        channelId: channelName,
        uid: callerId.hashCode % 4294967296,
        options: const RtcChannelMediaOptions(
          autoSubscribeAudio: true,
          autoSubscribeVideo: true,
          publishMicrophoneTrack: true,
          publishCameraTrack: true,
        ),
      );

      print('✓ Video call started: $channelName');
    } catch (e) {
      print('✗ Failed to start video call: $e');
      rethrow;
    }
  }

  @override
  Future<void> acceptCall(String callId) async {
    try {
      print('✓ Call accepted: $callId');
    } catch (e) {
      print('✗ Failed to accept call: $e');
      rethrow;
    }
  }

  @override
  Future<void> rejectCall(String callId) async {
    try {
      await endCall(callId);
      print('✓ Call rejected: $callId');
    } catch (e) {
      print('✗ Failed to reject call: $e');
      rethrow;
    }
  }

  @override
  Future<void> endCall(String callId) async {
    try {
      await _engine.leaveChannel();
      _callStreamController.add(
        Call(
          id: callId,
          callerId: '',
          callerName: '',
          receiverId: '',
          receiverName: '',
          callType: CallType.audio,
          status: CallStatus.ended,
          initiatedAt: DateTime.now(),
          isIncoming: false,
        ),
      );
      print('✓ Call ended: $callId');
    } catch (e) {
      print('✗ Failed to end call: $e');
      rethrow;
    }
  }

  @override
  Future<void> muteAudio(bool mute) async {
    try {
      await _engine.muteLocalAudioStream(mute);
      _isMuted = mute;
      print('${mute ? '✓ Microphone muted' : '✓ Microphone unmuted'}');
    } catch (e) {
      print('✗ Failed to mute audio: $e');
      rethrow;
    }
  }

  @override
  Future<void> enableSpeaker(bool enable) async {
    try {
      await _engine.setEnableSpeakerphone(enable);
      _isSpeakerEnabled = enable;
      print('${enable ? '✓ Speaker enabled' : '✓ Speaker disabled'}');
    } catch (e) {
      print('✗ Failed to toggle speaker: $e');
      rethrow;
    }
  }

  @override
  Future<void> enableCamera(bool enable) async {
    try {
      await _engine.enableLocalVideo(enable);
      _isCameraEnabled = enable;
      print('${enable ? '✓ Camera enabled' : '✓ Camera disabled'}');
    } catch (e) {
      print('✗ Failed to toggle camera: $e');
      rethrow;
    }
  }

  @override
  Future<void> switchCamera() async {
    try {
      await _engine.switchCamera();
      print('✓ Camera switched');
    } catch (e) {
      print('✗ Failed to switch camera: $e');
      rethrow;
    }
  }

  @override
  Stream<Call> getCallStream() {
    return _callStreamController.stream;
  }

  @override
  Stream<Call> getIncomingCallStream() {
    return _incomingCallStreamController.stream;
  }

  @override
  Future<void> dispose() async {
    try {
      await _engine.leaveChannel();
      await _engine.release();
      await _callStreamController.close();
      await _incomingCallStreamController.close();
      print('✓ Agora disposed');
    } catch (e) {
      print('✗ Error disposing Agora: $e');
    }
  }

  // Helper to generate unique channel name
  String _generateChannelName(String userId1, String userId2) {
    final users = [userId1, userId2]..sort();
    return 'call_${users[0]}_${users[1]}';
  }

  // Note: Video widgets are rendered in the UI layer using Agora's video view
  // For now, we display placeholder video UI
  // In production, integrate AgoraVideoView from agora_uikit
}
