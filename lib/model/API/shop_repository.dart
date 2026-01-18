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
}
