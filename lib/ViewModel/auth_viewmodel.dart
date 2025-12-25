import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/API/auth_repository.dart';
import '../model/auth_models.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repo;
  AuthViewModel({AuthRepository? repo}) : _repo = repo ?? AuthRepository();

  bool _loading = false;
  String? _error;
  AuthData? _auth;

  bool get isLoading => _loading;
  String? get error => _error;
  UserModel? get user => _auth?.user;
  String? get token => _auth?.token;
  bool get isAuthenticated => _auth != null && (_auth!.token.isNotEmpty);

  Future<void> _persistToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final t = prefs.getString('auth_token');
    if (t != null && t.isNotEmpty) {
      _auth = AuthData(
        user: const UserModel(
          id: '',
          name: '',
          lastName: '',
          username: '',
          email: '',
          userType: '',
        ),
        token: t,
      );
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await _repo.login(email: email, password: password);
      if (res.success && res.data != null) {
        _auth = res.data;
        await _persistToken(_auth!.token);
        return true;
      }
      _error = res.message ?? 'Error desconocido';
      return false;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> register({
    required String name,
    required String lastName,
    required String username,
    required String email,
    required String password,
    String? address,
    String? phone,
    String? dateOfBirth,
    String userType = 'customer',
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await _repo.register(
        name: name,
        lastName: lastName,
        username: username,
        email: email,
        password: password,
        address: address,
        phone: phone,
        dateOfBirth: dateOfBirth,
        userType: userType,
      );
      if (res.success && res.data != null) {
        _auth = res.data;
        await _persistToken(_auth!.token);
        return true;
      }
      _error = res.message ?? 'Error desconocido';
      return false;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _auth = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    notifyListeners();
  }
}
