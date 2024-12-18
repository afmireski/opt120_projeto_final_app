import 'package:flutter/material.dart';
import '../components/bottom-bar.dart';
import '../components/background-container.dart'; // Importa o BackgroundContainer

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent, // Deixa o fundo transparente
        body: Center(
          child: Text(
            'Bem-vindo ao Reserva Ai!',
            style: TextStyle(fontSize: 24, color: Colors.black),
          ),
        ),
      ),
    );
  }
}
