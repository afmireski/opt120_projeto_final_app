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
  static final UserStore _instance = UserStore._internal();

  User? _currentUser;
  String? _token;

  UserStore._internal();

  factory UserStore() => _instance;

  User? get currentUser => _currentUser;
  String? get token => _token;

  void setUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  void setToken(String token) {
    _token = token;
    notifyListeners();
  }

  void clearUser() {
    _currentUser = null;
    _token = null;
    notifyListeners();
  }
}
