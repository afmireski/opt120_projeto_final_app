import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importação para formatação de data
import '../../models/room.dart';
import '../../components/background-container.dart';
import 'create-room.dart';

class ListRooms extends StatefulWidget {
  const ListRooms({super.key});

  @override
  _ListRoomsState createState() => _ListRoomsState();
}

class _ListRoomsState extends State<ListRooms> {
  List<Room> _rooms = [];

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  void _loadMockData() {
    setState(() {
      _rooms = [
        Room(
          id: 1,
          name: "Sala 101",
          informations: {"instrumentos": "30 pessoas"},
          opening_hour: "00:00",
          closing_hour: "00:00",
        ),
        Room(
          id: 2,
          name: "Laboratório de Informática",
          informations: {"instrumentos": "20 pessoas"},
          opening_hour: "00:00",
          closing_hour: "00:00",
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _rooms.length,
        itemBuilder: (context, index) {
          final room = _rooms[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Barra preta à esquerda
                  Container(
                    width: 8,
                    height: 100,
                    color: Colors.black,
                  ),
                  const SizedBox(width: 16),
                  // Coluna com o nome e informações
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          room.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Exibe informações
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: room.informations.entries.map((entry) {
                            return Text(
                              '${entry.key}: ${entry.value}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 8),
                        // Horários
                        Row(
                          children: [
                            Text(
                              'Entrada: ${room.opening_hour}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Saída: ${room.closing_hour}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Botão de edição
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateRooms(
                            room: room, // Passa a sala para a página de criação/edição
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
