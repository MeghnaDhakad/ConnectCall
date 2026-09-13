import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../providers/call_provider.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_colors.dart';

class CallHistoryScreen extends ConsumerWidget {
  const CallHistoryScreen({Key? key}) : super(key: key);

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final callDate = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
    );

    if (callDate == today) {
      return 'Today, ${DateFormat('h:mm a').format(dateTime)}';
    } else if (callDate == yesterday) {
      return 'Yesterday, ${DateFormat('h:mm a').format(dateTime)}';
    } else {
      return DateFormat('MMM d, h:mm a').format(dateTime);
    }
  }

  IconData _getCallIcon(bool isIncoming, bool isMissed) {
    if (isMissed) {
      return Icons.call_missed;
    }
    return isIncoming ? Icons.call_received : Icons.call_made;
  }

  Color _getCallIconColor(bool isIncoming, bool isMissed) {
    if (isMissed) {
      return AppColors.error;
    }
    return isIncoming ? AppColors.success : AppColors.info;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final callHistoryAsync = ref.watch(callHistoryStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.callHistory),
        elevation: 0,
      ),
      body: callHistoryAsync.when(
        data: (callHistory) {
          if (callHistory.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.call_end,
                    size: 64,
                    color: AppColors.textLight.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.noCallHistory,
                    style: TextStyle(color: AppColors.textLight),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppStrings.startCalling,
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            itemCount: callHistory.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: AppColors.borderLight,
            ),
            itemBuilder: (context, index) {
              final call = callHistory[index];
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                leading: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: _getCallIconColor(call.isIncoming, call.isMissed)
                        .withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      _getCallIcon(call.isIncoming, call.isMissed),
                      color:
                          _getCallIconColor(call.isIncoming, call.isMissed),
                      size: 24,
                    ),
                  ),
                ),
                title: Text(
                  call.otherUserName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      _formatTime(call.timestamp),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(
                          call.callType.toString().contains('video')
                              ? Icons.videocam
                              : Icons.call,
                          size: 12,
                          color: AppColors.textLight,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          call.callType.toString().contains('video')
                              ? AppStrings.video
                              : AppStrings.audio,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (call.isMissed)
                      Text(
                        AppStrings.missed,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.error,
                              fontWeight: FontWeight.w600,
                            ),
                      )
                    else
                      Text(
                        call.formatDuration(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    const SizedBox(height: 4),
                    Icon(
                      Icons.more_vert,
                      size: 20,
                      color: AppColors.textLight,
                    ),
                  ],
                ),
                onTap: () {
                  // Show call details or options
                },
              );
            },
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.error.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'Failed to load call history',
                style: TextStyle(color: AppColors.error),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Retry logic
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
