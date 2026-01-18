import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class ShopRepository {
  final http.Client _client;
  ShopRepository({http.Client? client}) : _client = client ?? http.Client();

  Uri _url(String path) => Uri.parse('${ApiConfig.baseUrl}$path');

  Future<List<dynamic>> getShops() async {
    final response = await _client.get(_url('/api/shops'));

    if (response.statusCode != 200) {
      throw Exception('Error al obtener tiendas');
    }

    return jsonDecode(response.body) as List<dynamic>;
  }

  Future<List<dynamic>> getProductsByShop(String shopId) async {
    final response = await _client.get(_url('/api/shops/$shopId/products'));

    if (response.statusCode != 200) {
      throw Exception('Error al obtener productos de tienda');
    }

    return jsonDecode(response.body) as List<dynamic>;
  }

  Future<void> createShop(String token, String name, String address) async {
    final response = await _client.post(
      _url('/api/shops'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'name': name, 'address': address}),
    );

    if (response.statusCode != 201) {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'Error al crear la tienda');
    }
  }

  Future<List<dynamic>> getMyShops(String token) async {
    final response = await _client.get(
      _url('/api/shops/my-shops'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      // Si recibimos 404, puede significar que no tiene shops (o perfil no creado)
      if (response.statusCode == 404) return [];
      throw Exception('Error al obtener mis tiendas');
    }

    final json = jsonDecode(response.body);
    return json['data'] as List<dynamic>;
  }
}
