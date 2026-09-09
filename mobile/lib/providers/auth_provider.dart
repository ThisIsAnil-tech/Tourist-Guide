import 'package:flutter/foundation.dart';
import '../models/user_model.dart';
import '../services/api/auth_api.dart';
import '../services/secure_storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthApi _authApi;
  final SecureStorageService _storage;

  AuthProvider({required AuthApi authApi, required SecureStorageService storage})
      : _authApi = authApi,
        _storage = storage;

  UserModel? _user;
  bool _isLoading = true;

  UserModel? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;

  Future<void> restoreSession() async {
    _isLoading = true;
    notifyListeners();

    final accessToken = await _storage.getAccessToken();
    if (accessToken == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      _user = await _authApi.getCurrentUser();
    } catch (_) {
      await _storage.clearTokens();
      _user = null;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    final tokens = await _authApi.login(email, password);
    await _storage.saveTokens(tokens.accessToken, tokens.refreshToken);
    _user = await _authApi.getCurrentUser();
    notifyListeners();
  }

  Future<void> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    await _authApi.register(name: name, email: email, phone: phone, password: password);
    await login(email, password);
  }

  Future<void> logout() async {
    try {
      await _authApi.logout();
    } catch (_) {
      // proceed with local logout regardless of server response
    }
    await _storage.clearTokens();
    _user = null;
    notifyListeners();
  }

  Future<void> refreshUser() async {
    _user = await _authApi.getCurrentUser();
    notifyListeners();
  }
}