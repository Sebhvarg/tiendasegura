import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'api_config.dart';

class ProductRepository {
  final http.Client _client;
  ProductRepository({http.Client? client}) : _client = client ?? http.Client();

  Uri _url(String path) => Uri.parse('${ApiConfig.baseUrl}$path');

  Future<Map<String, dynamic>> createProduct({
    required String name,
    String? brand,
    double? price,
    String? netContent,
    String? netContentUnit,
    String? imageUrl,
  }) async {
    final body = {
      'name': name,
      'brand': brand,
      'price': price,
      'netContent': netContent,
      'netContentUnit': netContentUnit,
      'imageUrl': imageUrl,
    }..removeWhere((k, v) => v == null);

    final response = await _client.post(
      _url('/api/products/create'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}