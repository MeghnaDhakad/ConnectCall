import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/call.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_colors.dart';

class VideoCallScreen extends ConsumerStatefulWidget {
  final Call call;

  const VideoCallScreen({
    Key? key,
    required this.call,
  }) : super(key: key);

  @override
  ConsumerState<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends ConsumerState<VideoCallScreen> {
  bool _isMuted = false;
  bool _isCameraEnabled = true;
  bool _showControls = true;
  Duration _callDuration = Duration.zero;
  late Stopwatch _stopwatch;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch()..start();
    _startCallTimer();
  }

  @override
  void dispose() {
    _stopwatch.stop();
    super.dispose();
  }

  void _startCallTimer() {
    Future.delayed(Duration.zero, () {
      if (mounted) {
        setState(() {
          _callDuration = Duration(seconds: _stopwatch.elapsed.inSeconds);
        });
        Future.delayed(const Duration(seconds: 1), _startCallTimer);
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours == 0) {
      return '$minutes:$seconds';
    }
    return '$hours:$minutes:$seconds';
  }

  void _toggleMicrophone() {
    setState(() => _isMuted = !_isMuted);
    // Implement Agora mute call here
  }

  void _toggleCamera() {
    setState(() => _isCameraEnabled = !_isCameraEnabled);
    // Implement Agora camera toggle here
  }

  void _switchCamera() {
    // Implement Agora camera switch here
  }

  void _endCall() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: GestureDetector(
        onTap: () {
          setState(() => _showControls = !_showControls);
        },
        child: Stack(
          children: [
            // Remote Video (Full screen)
            Container(
              color: AppColors.darkGrey,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.videocam_off,
                        size: 60,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.call.getOtherPartyName(widget.call.callerId),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.white,
                          ),
                    ),
                  ],
                ),
              ),
            ),

            // Local Video (PIP - Picture in Picture)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                width: 100,
                height: 140,
                decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.videocam,
                    size: 40,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),

            // Call Info Header
            Positioned(
              top: 16,
              left: 16,
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatDuration(_callDuration),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ),

            // Controls (Animated)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              bottom: _showControls ? 32 : -100,
              left: 0,
              right: 0,
              child: Center(
                child: Column(
                  children: [
                    // Control Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Mute Button
                        GestureDetector(
                          onTap: _toggleMicrophone,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: _isMuted
                                  ? AppColors.error
                                  : AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _isMuted ? Icons.mic_off : Icons.mic,
                              color: AppColors.white,
                              size: 28,
                            ),
                          ),
                        ),

                        // Camera Button
                        GestureDetector(
                          onTap: _toggleCamera,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: _isCameraEnabled
                                  ? AppColors.primary
                                  : AppColors.error,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _isCameraEnabled
                                  ? Icons.videocam
                                  : Icons.videocam_off,
                              color: AppColors.white,
                              size: 28,
                            ),
                          ),
                        ),

                        // Switch Camera Button
                        GestureDetector(
                          onTap: _switchCamera,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.flip_camera_ios,
                              color: AppColors.white,
                              size: 28,
                            ),
                          ),
                        ),

                        // End Call Button
                        GestureDetector(
                          onTap: _endCall,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              color: AppColors.error,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.call_end,
                              color: AppColors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          _isMuted ? AppStrings.unmute : AppStrings.mute,
                          style: TextStyle(
                            color: AppColors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          _isCameraEnabled
                              ? AppStrings.camera
                              : 'Camera Off',
                          style: TextStyle(
                            color: AppColors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          AppStrings.switchCamera,
                          style: TextStyle(
                            color: AppColors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          AppStrings.endCall,
                          style: TextStyle(
                            color: AppColors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
