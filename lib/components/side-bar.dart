import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../stores/user-store.dart';

class SideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
           children: [
              Container(
                color: Color(0xFFFFD700),
                width: double.infinity, 
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: Row(
                  children: [
                    Text(
                      'ReservAi',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.grey,
                thickness: 1, 
                height: 1,
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
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirmar saída'),
                      content: const Text('Tem certeza que deseja desconectar?'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancelar'),
                          onPressed: () {
                            Navigator.of(context).pop(); // Fecha o modal
                          },
                        ),
                        TextButton(
                          child: const Text('Sim'),
                          onPressed: () {
                            // Limpa as informações do usuário e token no UserStore
                            final userStore = Provider.of<UserStore>(context, listen: false);
                            userStore.clearUser(); // Limpa o usuário e token

                            Navigator.of(context).pushReplacementNamed('/login'); // Redireciona para a tela de login
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
