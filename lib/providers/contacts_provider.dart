import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user.dart';
import '../../services/user/user_service.dart';
import 'auth_provider.dart';

final contactsServiceProvider = Provider((ref) => UserService());

// Stream provider for all contacts
final contactsStreamProvider = StreamProvider<List<User>>((ref) {
  final currentUserId = ref.watch(currentUserIdProvider);
  if (currentUserId == null) return Stream.value([]);

  final userService = ref.watch(contactsServiceProvider);
  return userService.getUsersStream(currentUserId);
});

// Future provider for all contacts
final contactsProvider = FutureProvider<List<User>>((ref) async {
  final currentUserId = ref.watch(currentUserIdProvider);
  if (currentUserId == null) return [];

  final userService = ref.watch(contactsServiceProvider);
  return userService.getAllUsers(currentUserId);
});

// Provider for online contacts only
final onlineContactsProvider = FutureProvider<List<User>>((ref) async {
  final currentUserId = ref.watch(currentUserIdProvider);
  if (currentUserId == null) return [];

  final userService = ref.watch(contactsServiceProvider);
  return userService.getOnlineContacts(currentUserId);
});

// State notifier for search
final searchNotifierProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  final userService = ref.watch(contactsServiceProvider);
  final currentUserId = ref.watch(currentUserIdProvider);
  return SearchNotifier(userService, currentUserId);
});

class SearchState {
  final bool isLoading;
  final List<User> results;
  final String? error;
  final String query;

  SearchState({
    required this.isLoading,
    required this.results,
    this.error,
    required this.query,
  });

  SearchState copyWith({
    bool? isLoading,
    List<User>? results,
    String? error,
    String? query,
  }) {
    return SearchState(
      isLoading: isLoading ?? this.isLoading,
      results: results ?? this.results,
      error: error ?? this.error,
      query: query ?? this.query,
    );
  }
}

class SearchNotifier extends StateNotifier<SearchState> {
  final UserService _userService;
  final String? _currentUserId;

  SearchNotifier(this._userService, this._currentUserId)
      : super(SearchState(isLoading: false, results: [], query: ''));

  Future<void> search(String query) async {
    if (_currentUserId == null) return;

    state = state.copyWith(isLoading: true, query: query, error: null);
    try {
      final results = await _userService.searchUsers(query, _currentUserId!);
      state = state.copyWith(isLoading: false, results: results);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearSearch() {
    state = SearchState(isLoading: false, results: [], query: '');
  }
}
