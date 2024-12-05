import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Organiza os itens
        children: [
          // Conteúdo principal da barra lateral
          Column(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.meeting_room_rounded),
                title: Text('Reservar Sala'),
                onTap: () {
                  // TODO: Adicionar navegação
                },
              ),
              ListTile(
                leading: Icon(Icons.approval_rounded),
                title: Text('Aprovar Reservas'),
                onTap: () {
                  // TODO: Adicionar navegação
                },
              ),
              ListTile(
                leading: Icon(Icons.add_business_rounded),
                title: Text('Criação de Sala'),
                onTap: () {
                  // TODO: Adicionar navegação
                },
              ),
              ListTile(
                leading: Icon(Icons.add_task_rounded),
                title: Text('Criação de Reserva'),
                onTap: () {
                  // TODO: Adicionar navegação
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListTile(
              leading: Icon(Icons.exit_to_app_rounded, color: Colors.red),
              title: Text(
                'Sair',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                // TODO: Implementar ação de logout
                Navigator.pop(context); // Fecha o menu lateral
              },
            ),
          ),
        ],
      ),
    );
  }
}
