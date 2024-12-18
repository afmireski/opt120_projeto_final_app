import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/room.dart';

class RoomService {
  final String baseUrl;

  RoomService(this.baseUrl);

  /// Criação de uma nova sala
  Future<Room> createRoom({
    required String name,
    required Map<String, dynamic> informations,
    required String openingHour, // Alterado para String
    required String closingHour, // Alterado para String
  }) async {
    final url = Uri.parse('$baseUrl/rooms/new');

    final body = {
      'name': name,
      'informations': informations,
      'opening_hour': openingHour, // Envia no formato "HH:mm"
      'closing_hour': closingHour, // Envia no formato "HH:mm"
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Room.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao criar a sala: ${response.body}');
    }
  }

  /// Atualização de uma sala existente
  Future<Room> updateRoom({
    required int id,
    String? name,
    Map<String, dynamic>? informations,
    String? openingHour, // Alterado para String
    String? closingHour, // Alterado para String
  }) async {
    final url = Uri.parse('$baseUrl/rooms/$id/update');

    final body = {
      if (name != null) 'name': name,
      if (informations != null) 'informations': informations,
      if (openingHour != null) 'opening_hour': openingHour, // Envia como String
      if (closingHour != null) 'closing_hour': closingHour, // Envia como String
    };

    final response = await http.patch(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Room.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao atualizar a sala: ${response.body}');
    }
  }

  /// Listagem de todas as salas
  Future<List<Room>> fetchRooms() async {
    final url = Uri.parse('$baseUrl/rooms');

    final response = await http.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> roomsJson = jsonDecode(response.body);
      return roomsJson.map((json) => Room.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar as salas: ${response.body}');
    }
  }
}
