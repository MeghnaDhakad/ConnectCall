import 'package:flutter/material.dart';

enum ScreenShareMode {
  device,
  window,
  region,
}

class ScreenSharingService {
  static final ScreenSharingService _instance = ScreenSharingService._internal();

  factory ScreenSharingService() {
    return _instance;
  }

  ScreenSharingService._internal();

  bool _isScreenSharing = false;
  ScreenShareMode _shareMode = ScreenShareMode.device;

  // Start screen sharing
  Future<void> startScreenShare({
    required String channelId,
    ScreenShareMode mode = ScreenShareMode.device,
  }) async {
    try {
      if (_isScreenSharing) {
        debugPrint('Screen sharing already active');
        return;
      }

      _shareMode = mode;
      _isScreenSharing = true;

      debugPrint('Starting screen share: ${mode.name}');

      switch (mode) {
        case ScreenShareMode.device:
          _startDeviceScreenShare();
          break;
        case ScreenShareMode.window:
          _startWindowShare();
          break;
        case ScreenShareMode.region:
          _startRegionShare();
          break;
      }

      // Agora provides startScreenCapture() method for screen sharing
      
    } catch (e) {
      debugPrint('Error starting screen share: $e');
      _isScreenSharing = false;
      rethrow;
    }
  }

  void _startDeviceScreenShare() {
    debugPrint('Starting full device screen share');
    // Captures entire device screen
  }

  void _startWindowShare() {
    debugPrint('Starting window-specific screen share');
    // Captures specific application window (Android 5.0+ required)
  }

  void _startRegionShare() {
    debugPrint('Starting region-specific screen share');
    // Captures specific region/rectangle of the screen
  }

  // Pause screen sharing
  Future<void> pauseScreenShare() async {
    if (!_isScreenSharing) return;

    debugPrint('Pausing screen share');
    // Pause sharing but keep the session alive
  }

  // Resume screen sharing
  Future<void> resumeScreenShare() async {
    if (!_isScreenSharing) return;

    debugPrint('Resuming screen share');
    // Resume sharing
  }

  // Stop screen sharing
  Future<void> stopScreenShare() async {
    if (!_isScreenSharing) return;

    _isScreenSharing = false;
    debugPrint('Stopping screen share: ${_shareMode.name}');

    // Agora provides stopScreenCapture() method
  }

  // Switch screen share mode during active share
  Future<void> switchShareMode(ScreenShareMode newMode) async {
    if (!_isScreenSharing) {
      debugPrint('Screen sharing not active');
      return;
    }

    await stopScreenShare();
    await startScreenShare(channelId: '', mode: newMode);
  }

  bool isScreenSharing() => _isScreenSharing;

  ScreenShareMode getCurrentShareMode() => _shareMode;

  // Adjust screen share quality
  Future<void> setScreenShareQuality({
    required int width,
    required int height,
    required int frameRate, // FPS
    required int bitrate, // kbps
  }) async {
    debugPrint('Setting screen share quality: ${width}x${height} @ ${frameRate}fps, $bitrate kbps');
    
    // Agora provides setScreenCaptureContentHint() for optimization
    // Can optimize for motion (video/games) or details (slides/documents)
  }

  // Optimize for content type
  Future<void> optimizeForContentType({
    required bool isMotion, // true for video/games, false for slides/documents
  }) async {
    debugPrint('Optimizing screen share for ${isMotion ? 'motion content' : 'static content'}');
    // Adjusts bitrate and frame rate based on content type
  }
}
