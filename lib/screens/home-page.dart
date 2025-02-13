  import 'package:flutter/material.dart';
  import '../components/bottom-bar.dart';
  import '../components/background-container.dart';

  class HomePage extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return BackgroundContainer(
        child: Scaffold(
          backgroundColor: Colors.transparent, // Mantém o fundo transparente para exibir a imagem
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildReservasAgendadas(),
                SizedBox(height: 20),
                _buildReservasPendentes(),
              ],
            ),
          ),
        ),
      );
    }

    Widget _buildReservasAgendadas() {
      final reservas = [
        {'sala': 'Sala 101', 'data': '12/02/2025 - 14:00'},
        {'sala': 'Sala 202', 'data': '13/02/2025 - 10:30'},
        {'sala': 'Sala 303', 'data': '14/02/2025 - 09:00'},
      ];

      return _buildReservaCard(
        title: 'Reservas Agendadas',
        children: [
          // Linha divisória abaixo do título
          Divider(color: Colors.grey[400], thickness: 1),
          SizedBox(height: 10),
          // GridView para exibir as salas em formato de quadrados
          GridView.count(
            shrinkWrap: true, // Para ocupar apenas o espaço necessário
            physics: NeverScrollableScrollPhysics(), // Desabilita o scroll interno
            crossAxisCount: 2, // Duas colunas
            crossAxisSpacing: 10, // Espaçamento horizontal entre os itens
            mainAxisSpacing: 10, // Espaçamento vertical entre os itens
            children: reservas.map((reserva) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300], // Cor cinza claro para os quadrados
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      reserva['sala']!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      reserva['data']!,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      );
    }

    Widget _buildReservasPendentes() {
      final reservas = [
        {'sala': 'Sala 105', 'status': 'Espera', 'color': Colors.yellow},
        {'sala': 'Sala 207', 'status': 'Rejeitado', 'color': Colors.red},
        {'sala': 'Sala 309', 'status': 'Aprovado', 'color': Colors.green},
      ];

      return _buildReservaCard(
        title: 'Reservas Pendentes',
        children: [
          // Linha divisória abaixo do título
          Divider(color: Colors.grey[400], thickness: 1),
          SizedBox(height: 10),
          // Listagem de reservas pendentes
          Column(
            children: reservas.map((reserva) {
              return Container(
                margin: EdgeInsets.only(bottom: 8), // Espaçamento entre os itens
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[300], // Cor cinza claro para os contêineres
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(reserva['sala']! as String, style: TextStyle(fontSize: 16,color: Colors.black)),
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: reserva['color'] as Color,
                            shape: BoxShape.circle,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text(reserva['status']! as String, style: TextStyle(color: Colors.black87)),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      );
    }

    Widget _buildReservaCard({required String title, required List<Widget> children}) {
      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white, // Fundo branco para o card
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            ...children, // Adiciona os filhos (linha divisória e listagem)
          ],
        ),
      );
    }
  }