import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import '../auth_models.dart';
import 'api_config.dart';


class AuthRepository {
  final http.Client _client;
  AuthRepository({http.Client? client}) : _client = client ?? http.Client();

  Uri _url(String path) => Uri.parse('${ApiConfig.baseUrl}$path');

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final response = await _client.post(
      _url('/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final map = jsonDecode(response.body) as Map<String, dynamic>;
    return AuthResponse.fromMap(map);
  }

  Future<AuthResponse> register({
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
    final body = {
      'name': name,
      'lastName': lastName,
      'username': username,
      'email': email,
      'password': password,
      'address': address,
      'phone': phone,
      'DateOfBirth': dateOfBirth,
      'userType': userType,
    }..removeWhere((key, value) => value == null);

    final response = await _client.post(
      _url('/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    final map = jsonDecode(response.body) as Map<String, dynamic>;
    return AuthResponse.fromMap(map);
  }
}
