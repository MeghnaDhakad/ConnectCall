import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/call.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_colors.dart';

class IncomingCallScreen extends ConsumerStatefulWidget {
  final Call call;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const IncomingCallScreen({
    Key? key,
    required this.call,
    required this.onAccept,
    required this.onReject,
  }) : super(key: key);

  @override
  ConsumerState<IncomingCallScreen> createState() =>
      _IncomingCallScreenState();
}

class _IncomingCallScreenState extends ConsumerState<IncomingCallScreen> {
  bool _isRinging = true;

  @override
  void initState() {
    super.initState();
    // Simulate ringing animation
    _animateRinging();
  }

  void _animateRinging() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _isRinging = !_isRinging);
        _animateRinging();
      }
    });
  }

  void _handleAccept() {
    widget.onAccept();
  }

  void _handleReject() {
    widget.onReject();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isVideoCall = widget.call.callType == CallType.video;

    return Scaffold(
      backgroundColor: AppColors.darkGrey,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Call Type Indicator
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Text(
                isVideoCall
                    ? AppStrings.incomingVideoCall
                    : AppStrings.incomingAudioCall,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.white.withOpacity(0.7),
                    ),
              ),
            ),

            // Caller Info
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  // Profile Picture with Ringing Animation
                  ScaleTransition(
                    scale: _isRinging
                        ? AlwaysStoppedAnimation(1.0)
                        : AlwaysStoppedAnimation(0.95),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.2),
                        shape: BoxShape.circle,
                        boxShadow: _isRinging
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.4),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ]
                            : [],
                      ),
                      child: Icon(
                        isVideoCall ? Icons.videocam : Icons.person,
                        size: 60,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Caller Name
                  Text(
                    widget.call.getOtherPartyName(widget.call.receiverId),
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),

                  // Ringing Status
                  Text(
                    AppStrings.calling,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.white.withOpacity(0.7),
                        ),
                  ),
                ],
              ),
            ),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.only(bottom: 48),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Reject Button
                  GestureDetector(
                    onTap: _handleReject,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.call_end,
                        color: AppColors.white,
                        size: 36,
                      ),
                    ),
                  ),

                  // Accept Button
                  GestureDetector(
                    onTap: _handleAccept,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isVideoCall ? Icons.videocam : Icons.call,
                        color: AppColors.white,
                        size: 36,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Button Labels
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    AppStrings.decline,
                    style: TextStyle(
                      color: AppColors.white.withOpacity(0.7),
                    ),
                  ),
                  Text(
                    AppStrings.accept,
                    style: TextStyle(
                      color: AppColors.white.withOpacity(0.7),
                    ),
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
