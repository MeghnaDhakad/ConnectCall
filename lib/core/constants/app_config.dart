class AppConfig {
  // Agora Configuration ✅ CONFIGURED
  static const String agoraAppId = 'ec929c7d9b724028bb07c2c39db9701d';
  // Agora App ID configured for production use
  
  // Agora Token (for testing, you can generate from Agora Console)
  // In production, generate tokens from your backend
  static const String agoraToken = '';
  
  // Firebase Configuration
  // Already handled in firebase_options.dart

  // Call timeouts
  static const int callTimeoutSeconds = 60;
  static const int callRingingDurationSeconds = 45;

  // UI Constants
  static const double borderRadius = 12.0;
  static const double buttonHeight = 48.0;
  static const double appBarHeight = 56.0;

  // API Endpoints (if using custom backend)
  static const String baseUrl = 'https://your-backend.com/api';
  static const String signTokenUrl = '$baseUrl/rtc/access_token';
}

// Verify you have Firebase configured before running
// Follow: https://firebase.google.com/docs/flutter/setup
