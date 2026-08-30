import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final bool isGuest;
  final UserModel? user;
  final String? errorMessage;

  AuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.isGuest = false,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    bool? isGuest,
    UserModel? user,
    String? errorMessage,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isGuest: isGuest ?? this.isGuest,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final ApiService _api = ApiService();
  final StorageService _storage = StorageService();

  AuthNotifier() : super(AuthState(isLoading: true)) {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    state = state.copyWith(isLoading: true);
    // Allow preloader wave animation to display smoothly on startup
    await Future.delayed(const Duration(milliseconds: 1500));
    try {
      final token = await _storage.getToken();
      if (token != null && token.isNotEmpty) {
        final user = await _api.getCurrentUser();
        state = AuthState(
          isAuthenticated: true,
          isGuest: false,
          user: user,
          isLoading: false,
        );
        return;
      }
    } catch (_) {}
    state = AuthState(isAuthenticated: false, isGuest: true, isLoading: false);
  }

  Future<bool> login(String username, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _api.login(username, password);
      final user = await _api.getCurrentUser();
      state = AuthState(
        isAuthenticated: true,
        isGuest: false,
        user: user,
        isLoading: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return false;
    }
  }

  Future<void> continueAsGuest() async {
    state = AuthState(
      isAuthenticated: false,
      isGuest: true,
      isLoading: false,
    );
  }

  void goToLogin() {
    state = AuthState(
      isAuthenticated: false,
      isGuest: false,
      isLoading: false,
    );
  }

  Future<void> logout() async {
    await _storage.clearAll();
    state = AuthState(
      isAuthenticated: false,
      isGuest: true,
      isLoading: false,
    );
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
