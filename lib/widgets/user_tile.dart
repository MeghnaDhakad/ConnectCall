import 'package:flutter/material.dart';
import '../models/user.dart';
import '../core/constants/app_colors.dart';

class UserTile extends StatelessWidget {
  final User user;
  final VoidCallback? onAudioCall;
  final VoidCallback? onVideoCall;

  const UserTile({
    Key? key,
    required this.user,
    this.onAudioCall,
    this.onVideoCall,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          // Profile Picture
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.person,
                size: 32,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  user.name,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: user.isOnline
                            ? AppColors.success
                            : AppColors.textLight,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      user.isOnline ? 'Online' : 'Offline',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: user.isOnline
                                ? AppColors.success
                                : AppColors.textLight,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Call Buttons
          SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Audio Call Button
                GestureDetector(
                  onTap: user.isOnline ? onAudioCall : null,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: user.isOnline
                          ? AppColors.primary
                          : AppColors.primary.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.call,
                      size: 20,
                      color: AppColors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Video Call Button
                GestureDetector(
                  onTap: user.isOnline ? onVideoCall : null,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: user.isOnline
                          ? AppColors.accent
                          : AppColors.accent.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.videocam,
                      size: 20,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
