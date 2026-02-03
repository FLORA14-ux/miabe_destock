import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // ⚠️ IMPORTANT
  // Android Emulator → http://10.0.2.2:8000
  // iOS Simulator / Web → http://127.0.0.1:8000
  // Téléphone réel → http://IP_DE_TON_PC:8000

  //  A décochez quand il s'agit d'un téléphone :
  //static const String baseUrl = 'http://10.0.2.2:8000/api';

  // Version pour le web:
  static const String baseUrl = "http://127.0.0.1:8000/api";

  // ---------------- REGISTER ----------------
  static Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
    String passwordConfirmation,
  ) async {
    final url = Uri.parse('$baseUrl/register');

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      }),
    );

    return _handleResponse(response);
  }

  // ---------------- LOGIN ----------------
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final url = Uri.parse('$baseUrl/login');

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );

    return _handleResponse(response);
  }

  // ---------------- LOGOUT ----------------
  static Future<void> logout(String token) async {
    final url = Uri.parse('$baseUrl/logout');

    await http.post(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
  }

  // ---------------- HANDLER ----------------
  static Map<String, dynamic> _handleResponse(http.Response response) {
    final data = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      return {'message': data['message'] ?? 'Erreur serveur'};
    }
  }
}
