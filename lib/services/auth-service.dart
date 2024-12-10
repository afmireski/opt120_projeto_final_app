import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl;

  AuthService(this.baseUrl);

  Future<Map<String, dynamic>> login({
    String? email,
    String? ra,
    required String senha,
  }) async {
    final url = Uri.parse('$baseUrl/login');

    // Define o corpo da requisição dinamicamente
    final body = email != null
        ? {'email': email, 'senha': senha}
        : {'ra': ra, 'senha': senha};

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Retorna os dados do login
    } else {
      throw Exception('Erro ao realizar login: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> fetchUserById(int id) async {
    final url = Uri.parse('$baseUrl/api/users/$id');
    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body); // Retorna as informações do usuário
    } else {
      throw Exception('Erro ao buscar usuário: ${response.body}');
    }
  }
}
