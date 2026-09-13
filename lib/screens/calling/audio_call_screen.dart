import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/call.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_colors.dart';

class AudioCallScreen extends ConsumerStatefulWidget {
  final Call call;

  const AudioCallScreen({
    Key? key,
    required this.call,
  }) : super(key: key);

  @override
  ConsumerState<AudioCallScreen> createState() => _AudioCallScreenState();
}

class _AudioCallScreenState extends ConsumerState<AudioCallScreen> {
  bool _isMuted = false;
  bool _isSpeakerEnabled = false;
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

  void _toggleSpeaker() {
    setState(() => _isSpeakerEnabled = !_isSpeakerEnabled);
    // Implement Agora speaker toggle here
  }

  void _endCall() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkGrey,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Header with caller info
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.call.getOtherPartyName(widget.call.callerId),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.white,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatDuration(_callDuration),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.white.withOpacity(0.7),
                        ),
                  ),
                ],
              ),
            ),

            // Call Controls
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                children: [
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

                      // Speaker Button
                      GestureDetector(
                        onTap: _toggleSpeaker,
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: _isSpeakerEnabled
                                ? AppColors.primary
                                : AppColors.primary.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isSpeakerEnabled
                                ? Icons.volume_up
                                : Icons.volume_off,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isMuted ? AppStrings.unmute : AppStrings.mute,
                        style: TextStyle(color: AppColors.white.withOpacity(0.7)),
                      ),
                      const SizedBox(width: 24),
                      Text(
                        AppStrings.speaker,
                        style: TextStyle(color: AppColors.white.withOpacity(0.7)),
                      ),
                      const SizedBox(width: 24),
                      Text(
                        AppStrings.endCall,
                        style: TextStyle(color: AppColors.white.withOpacity(0.7)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
