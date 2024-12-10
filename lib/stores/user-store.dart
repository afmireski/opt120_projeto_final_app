import 'package:flutter/material.dart';

class User {
  final String nome;
  final String email;
  final String ra;
  final String role;

  User({
    required this.nome,
    required this.email,
    required this.ra,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      nome: json['nome'],
      email: json['email'],
      ra: json['ra'],
      role: json['role'],
    );
  }
}

class UserStore with ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  void setUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void clearUser() {
    _currentUser = null;
    notifyListeners();
  }
}
