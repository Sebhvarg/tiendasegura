import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class ProductRepository {
  final http.Client _client;
  ProductRepository({http.Client? client}) : _client = client ?? http.Client();

  Uri _url(String path) => Uri.parse('${ApiConfig.baseUrl}$path');

  Future<Map<String, dynamic>> createProduct({
    required String token,
    required String name,
    String? brand,
    double? price,
    String? description,
    int? stock,
    double? netContent,
    String? netContentUnit,
    String? imageUrl,
    File? imageFile,
  }) async {
    final request = http.MultipartRequest('POST', _url('/api/products/create'));
    request.headers['Authorization'] = 'Bearer $token';

    // Add fields
    request.fields['name'] = name;
    request.fields['price'] = price.toString();
    if (brand != null) request.fields['brand'] = brand;
    if (description != null) request.fields['description'] = description;
    if (stock != null) request.fields['stock'] = stock.toString();
    if (netContent != null)
      request.fields['netContent'] = netContent.toString();
    if (netContentUnit != null)
      request.fields['netContentUnit'] = netContentUnit;
    if (imageUrl != null) request.fields['imageUrl'] = imageUrl;

    // Add file
    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('productImage', imageFile.path),
      );
    }

    final streamlinedResponse = await _client.send(request);
    final response = await http.Response.fromStream(streamlinedResponse);

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
    File? imageFile,
  }) async {
    final request = http.MultipartRequest('PUT', _url('/api/products/$id'));
    request.headers['Authorization'] = 'Bearer $token';

    // Add fields
    request.fields['name'] = name;
    if (price != null) request.fields['price'] = price.toString();
    if (brand != null) request.fields['brand'] = brand;
    if (description != null) request.fields['description'] = description;
    if (stock != null) request.fields['stock'] = stock.toString();
    if (netContent != null)
      request.fields['netContent'] = netContent.toString();
    if (netContentUnit != null)
      request.fields['netContentUnit'] = netContentUnit;
    if (imageUrl != null) request.fields['imageUrl'] = imageUrl;

    // Add file
    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('productImage', imageFile.path),
      );
    }

    final streamlinedResponse = await _client.send(request);
    final response = await http.Response.fromStream(streamlinedResponse);

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar producto');
    }
  }

  Future<List<dynamic>> getAllProducts() async {
    final response = await _client.get(_url('/api/products/'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else {
      throw Exception('Error al cargar productos');
    }
  }
}
