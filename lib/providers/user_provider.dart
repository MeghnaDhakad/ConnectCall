import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user.dart';
import '../../services/user/user_service.dart';
import 'auth_provider.dart';

final userServiceProvider = Provider((ref) => UserService());

// Provider for current user profile
final currentUserProfileProvider = FutureProvider<User?>((ref) async {
  final currentUserId = ref.watch(currentUserIdProvider);
  if (currentUserId == null) return null;

  final userService = ref.watch(userServiceProvider);
  return userService.getUserById(currentUserId);
});

// Stream provider for current user real-time updates
final currentUserStreamProvider = StreamProvider<User?>((ref) {
  final currentUserId = ref.watch(currentUserIdProvider);
  if (currentUserId == null) return Stream.value(null);

  final userService = ref.watch(userServiceProvider);
  return userService.getUserStream(currentUserId);
});

// Provider for a specific user
final userByIdProvider = FutureProvider.family<User?, String>((ref, userId) async {
  final userService = ref.watch(userServiceProvider);
  return userService.getUserById(userId);
});

// Stream provider for a specific user
final userStreamByIdProvider = StreamProvider.family<User?, String>((ref, userId) {
  final userService = ref.watch(userServiceProvider);
  return userService.getUserStream(userId);
});

// State notifier for user profile updates
final userNotifierProvider = StateNotifierProvider<UserNotifier, UserState>((ref) {
  final userService = ref.watch(userServiceProvider);
  return UserNotifier(userService);
});

class UserState {
  final bool isLoading;
  final User? user;
  final String? error;

  UserState({
    required this.isLoading,
    this.user,
    this.error,
  });

  UserState copyWith({
    bool? isLoading,
    User? user,
    String? error,
  }) {
    return UserState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }
}

class UserNotifier extends StateNotifier<UserState> {
  final UserService _userService;

  UserNotifier(this._userService) : super(UserState(isLoading: false));

  Future<void> updateProfile({
    required String userId,
    required String name,
    String? phone,
    String? profilePhotoUrl,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _userService.updateUserProfile(
        userId: userId,
        name: name,
        phone: phone,
        profilePhotoUrl: profilePhotoUrl,
      );
      state = state.copyWith(isLoading: false, user: user);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> blockUser(String userId, String blockedUserId) async {
    try {
      await _userService.blockUser(userId, blockedUserId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }

  Future<void> unblockUser(String userId, String blockedUserId) async {
    try {
      await _userService.unblockUser(userId, blockedUserId);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      rethrow;
    }
  }
}
