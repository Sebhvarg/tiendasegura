import 'dart:convert';
import 'dart:io';
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
    File? imageFile,
  }) async {
    final request = http.MultipartRequest('POST', _url('/api/auth/register'));

    // Campos de texto
    request.fields['name'] = name;
    request.fields['lastName'] = lastName;
    request.fields['username'] = username;
    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['userType'] = userType;
    if (address != null) request.fields['address'] = address;
    if (phone != null) request.fields['phone'] = phone;
    if (dateOfBirth != null) request.fields['DateOfBirth'] = dateOfBirth;

    // Archivo
    if (imageFile != null) {
      if (kIsWeb) {
        // Lógica para web sies necesaria (no implementada aquí para File dart:io)
      } else {
        request.files.add(
          await http.MultipartFile.fromPath('cedulaPhoto', imageFile.path),
        );
      }
    }

    final streamlinedResponse = await _client.send(request);
    final response = await http.Response.fromStream(streamlinedResponse);

    final map = jsonDecode(response.body) as Map<String, dynamic>;
    return AuthResponse.fromMap(map);
  }
}
