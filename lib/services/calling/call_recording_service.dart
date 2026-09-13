import 'package:flutter/material.dart';

enum RecordingState {
  idle,
  recording,
  paused,
  stopped,
}

class CallRecordingService {
  static final CallRecordingService _instance = CallRecordingService._internal();

  factory CallRecordingService() {
    return _instance;
  }

  CallRecordingService._internal();

  RecordingState _recordingState = RecordingState.idle;
  String? _currentRecordingId;
  DateTime? _recordingStartTime;

  // Start recording call
  Future<void> startRecording({
    required String channelId,
    required String userId,
  }) async {
    try {
      if (_recordingState != RecordingState.idle) {
        debugPrint('Recording already in progress');
        return;
      }

      _recordingState = RecordingState.recording;
      _currentRecordingId = '${channelId}_${DateTime.now().millisecondsSinceEpoch}';
      _recordingStartTime = DateTime.now();

      debugPrint('Starting call recording: $_currentRecordingId');

      // Agora Cloud Recording API would be used here
      // This starts the recording on Agora's servers

    } catch (e) {
      debugPrint('Error starting recording: $e');
      _recordingState = RecordingState.idle;
      rethrow;
    }
  }

  // Pause recording
  Future<void> pauseRecording() async {
    if (_recordingState != RecordingState.recording) return;

    _recordingState = RecordingState.paused;
    debugPrint('Recording paused: $_currentRecordingId');
  }

  // Resume recording
  Future<void> resumeRecording() async {
    if (_recordingState != RecordingState.paused) return;

    _recordingState = RecordingState.recording;
    debugPrint('Recording resumed: $_currentRecordingId');
  }

  // Stop recording
  Future<void> stopRecording() async {
    if (_recordingState == RecordingState.idle) return;

    _recordingState = RecordingState.stopped;
    
    Duration recordingDuration = DateTime.now().difference(_recordingStartTime ?? DateTime.now());
    
    debugPrint('Recording stopped: $_currentRecordingId');
    debugPrint('Recording duration: ${recordingDuration.inMinutes}m ${recordingDuration.inSeconds % 60}s');

    // Save recording metadata
    _saveRecordingMetadata(recordingDuration);

    _currentRecordingId = null;
    _recordingStartTime = null;
    _recordingState = RecordingState.idle;
  }

  void _saveRecordingMetadata(Duration duration) {
    // Save recording info to Firestore
    debugPrint('Saving recording metadata for: $_currentRecordingId');
    // Recording would be saved to Firebase Storage with metadata in Firestore
  }

  RecordingState getRecordingState() => _recordingState;

  String? getCurrentRecordingId() => _currentRecordingId;

  bool isRecording() => _recordingState == RecordingState.recording;

  // Get recording duration
  Duration? getRecordingDuration() {
    if (_recordingStartTime == null) return null;
    return DateTime.now().difference(_recordingStartTime!);
  }

  // Delete recording
  Future<void> deleteRecording(String recordingId) async {
    debugPrint('Deleting recording: $recordingId');
    // Delete from Firebase Storage and remove metadata from Firestore
  }

  // Share recording
  Future<void> shareRecording({
    required String recordingId,
    required List<String> recipientIds,
  }) async {
    debugPrint('Sharing recording $recordingId with users: $recipientIds');
    // Update Firestore to grant access to specified users
  }
}
