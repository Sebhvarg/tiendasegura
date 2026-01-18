import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/API/auth_repository.dart';
import '../model/API/shop_repository.dart';
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
      // Nota: Aquí no tenemos los datos completos del usuario, idealmente deberíamos hacer un 'getMe'
      // Por simplicidad, asumimos estado básico y luego checkSellerStatus intentará actualizar si es posible
      // Ojo: userType estará vacío aquí, lo que fallará en checkSellerStatus.
      // Necesitamos persistir userType o hacer fetch profile.
      // Omitiré checkSellerStatus aquí por ahora para evitar bugs complejos sin fetch profile.
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
        await checkSellerStatus(); // Verificar tienda
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
        await checkSellerStatus();
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

  // -- Lógica de Vendedor --
  bool _hasShop = false;
  List<dynamic> _shops = []; // Stores the list of shops owned by the user

  bool get hasShop => _hasShop;
  List<dynamic> get shops => _shops;

  Future<void> checkSellerStatus() async {
    if (!isAuthenticated ||
        (user!.userType != 'seller' && user!.userType != 'shop_owner'))
      return;

    try {
      final fetchedShops = await ShopRepository().getMyShops(token!);
      _shops = fetchedShops;
      _hasShop = _shops.isNotEmpty;
      notifyListeners();
    } catch (e) {
      print('Error verificando status de vendedor: $e');
    }
  }

  Future<bool> createShop(String name, String address) async {
    if (!isAuthenticated) return false;
    _loading = true;
    notifyListeners();
    try {
      await ShopRepository().createShop(token!, name, address);
      _hasShop = true;
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
