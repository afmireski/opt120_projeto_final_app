//------------------------------------------------
//  MODELO DE USUÁRIO
//------------------------------------------------

class User {
  final int id;
  final String name;
  final String email;
  final String ra;
  final String password;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.ra,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      ra: json['ra'] ?? '',
      password: json['password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'ra': ra,
      'password': password,
    };
  }
}
