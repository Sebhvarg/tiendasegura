import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class OrderRepository {
  final String baseUrl = "http://localhost:3000/api/orders";

  Future<void> createOrder({
    required String token,
    required String clientId,
    required String shopId,
    required List<Map<String, dynamic>> products,
    required String address,
    required String paymentMethod,
    required double totalPrice,
  }) async {
    final url = Uri.parse("$baseUrl/create");
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "clientId": clientId,
          "shopId": shopId,
          "products": products,
          "address": address,
          "paymentMethod": paymentMethod,
          "totalPrice": totalPrice,
        }),
      );

      if (response.statusCode != 201) {
        throw Exception("Error creating order: ${response.body}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error creating order: $e");
      }
      rethrow;
    }
  }

  Future<List<dynamic>> getOrdersByShop(String shopId, String token) async {
    final url = Uri.parse("$baseUrl/shop/$shopId");
    try {
      final response = await http.get(
        url,
        headers: {"Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Error fetching orders: ${response.body}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching orders: $e");
      }
      rethrow;
    }
  }

  Future<void> updateOrderStatus(
    String orderId,
    String status,
    String token,
  ) async {
    final url = Uri.parse("$baseUrl/$orderId/status");
    try {
      final response = await http.put(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"status": status}),
      );

      if (response.statusCode != 200) {
        throw Exception("Error updating status: ${response.body}");
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error updating status: $e");
      }
      rethrow;
    }
  }
}
