import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabTapped;

  BottomBar({required this.currentIndex, required this.onTabTapped});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTabTapped,
      selectedItemColor: Colors.yellow, // Cor do item selecionado
      unselectedItemColor: Colors.grey, // Cor do item não selecionado
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment_rounded),
          label: 'Minhas Reservas',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_rounded),
          label: 'Perfil',
        ),
      ],
    );
  }
}
