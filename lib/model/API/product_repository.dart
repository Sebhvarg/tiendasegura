import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class ProductRepository {
  final http.Client _client;
  ProductRepository({http.Client? client}) : _client = client ?? http.Client();

  Uri _url(String path) => Uri.parse('${ApiConfig.baseUrl}$path');

  Future<Map<String, dynamic>> createProduct({
    required String token, // Token required
    required String name,
    String? brand,
    double? price,
    String? description,
    int? stock,
    double? netContent,
    String? netContentUnit,
    String? imageUrl,
  }) async {
    final body = {
      'name': name,
      'brand': brand,
      'price': price,
      'description': description,
      'stock': stock,
      'netContent': netContent,
      'netContentUnit': netContentUnit,
      'imageUrl': imageUrl,
    }..removeWhere((k, v) => v == null);

    final response = await _client.post(
      _url('/api/products/create'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 201) {
      final err = jsonDecode(response.body);
      throw Exception(err['message'] ?? 'Error al crear producto');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<String?> searchProductImage({
    required String name,
    String? brand,
    double? netContent,
    String? netContentUnit,
  }) async {
    final body = {
      'name': name,
      'brand': brand,
      'netContent': netContent,
      'netContentUnit': netContentUnit,
    }..removeWhere((k, v) => v == null);

    try {
      final response = await _client.post(
        _url('/api/products/search-image'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['imageUrl'] != null) {
          return data['imageUrl'].toString();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error searching image: $e');
      }
    }
    return null;
  }

  Future<void> deleteProduct({
    required String token,
    required String id,
  }) async {
    final response = await _client.delete(
      _url('/api/products/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar producto');
    }
  }

  Future<void> updateProduct({
    required String token,
    required String id,
    required String name,
    String? brand,
    double? price,
    String? description,
    int? stock,
    double? netContent,
    String? netContentUnit,
    String? imageUrl,
  }) async {
    final body = {
      'name': name,
      'brand': brand,
      'price': price,
      'description': description,
      'stock': stock,
      'netContent': netContent,
      'netContentUnit': netContentUnit,
      'imageUrl': imageUrl,
    }..removeWhere((k, v) => v == null);

    final response = await _client.put(
      _url('/api/products/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar producto');
    }
  }
}
