//------------------------------------------------
// REQUISIÇÕES E DADOS DO USUÁRIO PARA O SISTEMA
//------------------------------------------------


//!! EXEMPLOS DE FETCH DATAS E REQUISIÇÕES !! - REESTRUTURAR DE ACORDO COM O BACK

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class UserStore {
  final String apiUrl = '#######';

  Future<List<User>> fetchUsers() async {
    final url = Uri.parse('$apiUrl/users');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        print('Erro ao carregar users. Código: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Erro ao conectar-se ao backend: $e');
      return [];
    }
  }

  Future<User?> fetchUserById(int id) async {
    final url = Uri.parse('$apiUrl/user/$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return User.fromJson(data);
    } else {
      print('Erro ao buscar user. Código: ${response.statusCode}');
      return null;
    }
  }

   Future<void> addUser(User user) async {
    final url = Uri.parse('$apiUrl/user');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );

    if (response.statusCode != 201) {
      print('Erro ao criar user! Código: ${response.statusCode}');
      print('Resposta: ${response.body}');
    } else {
      print('user criado com sucesso!');
    }
  }

  Future<void> updateUser(User user) async {
    final url = Uri.parse('$apiUrl/user/${user.id}');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Erro ao atualizar user');
    }
  }

  Future<void> deleteUser(int id) async {
    final url = Uri.parse('$apiUrl/user/$id');
    final response = await http.delete(url);

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Erro ao excluir user');
    }
  }
}
