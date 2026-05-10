import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/product.dart';
import '../utils/constants.dart';

class ApiService {
  final storage = FlutterSecureStorage();

  // LOGIN
  Future<String?> login(String nim, String password) async {
    try {
      final url = Uri.parse('https://${Constants.baseUrl}/api/auth/login');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': nim, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null && data['data']['token'] != null) {
          String token = data['data']['token'];
          await storage.write(key: Constants.tokenKey, value: token);
          return token;
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<String?> getToken() async {
    return await storage.read(key: Constants.tokenKey);
  }

  Future<void> logout() async {
    await storage.delete(key: Constants.tokenKey);
  }

  // GET PRODUCTS - FIXED
  Future<List<Product>> getProducts() async {
    try {
      final token = await getToken();
      if (token == null) return [];

      final url = Uri.parse('https://${Constants.baseUrl}/api/products');

      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Perbaikan: akses ke data['data']['products']
        if (data['data'] != null && data['data']['products'] != null) {
          List list = data['data']['products'];
          return list.map((json) => Product.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // CREATE PRODUCT
  Future<bool> createProduct(String name, int price, String description) async {
    try {
      final token = await getToken();
      if (token == null) return false;

      final url = Uri.parse('https://${Constants.baseUrl}/api/products');

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'price': price,
          'description': description,
        }),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  // DELETE PRODUCT
  Future<bool> deleteProduct(int id) async {
    try {
      final token = await getToken();
      if (token == null) return false;

      final url = Uri.parse('https://${Constants.baseUrl}/api/products/$id');

      final response = await http.delete(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // SUBMIT TUGAS
  Future<bool> submitTask(
    String name,
    int price,
    String description,
    String githubUrl,
  ) async {
    try {
      final token = await getToken();
      if (token == null) return false;

      final url = Uri.parse('https://${Constants.baseUrl}/api/products/submit');

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'price': price,
          'description': description,
          'github_url': githubUrl,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
