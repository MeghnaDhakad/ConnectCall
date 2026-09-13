import 'package:flutter/material.dart';

class GroupCallingService {
  static final GroupCallingService _instance = GroupCallingService._internal();

  factory GroupCallingService() {
    return _instance;
  }

  GroupCallingService._internal();

  // Store active group call participants
  List<String> _participants = [];
  String? _currentGroupChannelId;

  // Initialize group call
  Future<void> startGroupCall({
    required String channelId,
    required List<String> participantIds,
    required String initiatorId,
  }) async {
    try {
      _currentGroupChannelId = channelId;
      _participants = participantIds;

      debugPrint('Starting group call: $channelId');
      debugPrint('Participants: $_participants');

      // Agora group call setup would go here
      // For now, this is the framework structure
    } catch (e) {
      debugPrint('Error starting group call: $e');
      rethrow;
    }
  }

  // Add participant to ongoing group call
  Future<void> addParticipant(String userId) async {
    if (_participants.contains(userId)) return;

    _participants.add(userId);
    debugPrint('Added participant: $userId');
    debugPrint('Total participants: ${_participants.length}');

    // Notify other participants
    _notifyParticipantAdded(userId);
  }

  // Remove participant from group call
  Future<void> removeParticipant(String userId) async {
    _participants.remove(userId);
    debugPrint('Removed participant: $userId');
    debugPrint('Remaining participants: ${_participants.length}');

    // If only 1 participant left, end the call
    if (_participants.length <= 1) {
      await endGroupCall();
    }
  }

  // End group call
  Future<void> endGroupCall() async {
    debugPrint('Ending group call: $_currentGroupChannelId');
    _participants.clear();
    _currentGroupChannelId = null;
  }

  // Get current participants
  List<String> getParticipants() => _participants;

  // Get group call info
  Map<String, dynamic> getGroupCallInfo() {
    return {
      'channelId': _currentGroupChannelId,
      'participantCount': _participants.length,
      'participants': _participants,
      'isActive': _currentGroupChannelId != null,
    };
  }

  void _notifyParticipantAdded(String userId) {
    debugPrint('Notifying participants about new user: $userId');
    // Implementation for notifying existing participants
  }

  // Switch between participants in group call
  Future<void> switchFocusParticipant(String userId) async {
    if (!_participants.contains(userId)) return;

    debugPrint('Switching focus to participant: $userId');
    // Agora provides APIs to switch focus between remote users
  }

  // Mute/Unmute participant in group call (admin only)
  Future<void> muteParticipant({
    required String userId,
    required bool mute,
  }) async {
    debugPrint('${mute ? 'Muting' : 'Unmuting'} participant: $userId');
    // Agora provides APIs for host-side muting
  }
}
