//------------------------------------------------
//  MODELO DE SALA
//------------------------------------------------

class Room {
  final int id;
  final String name;
  final Map<String, dynamic> informations; // Representa o campo Record
  final DateTime openingHour;
  final DateTime closingHour;

  Room({
    required this.id,
    required this.name,
    required this.informations,
    required this.openingHour,
    required this.closingHour,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      informations: json['informations'] ?? {},
      openingHour: DateTime.tryParse(json['opening_hour'] ?? '') ?? DateTime(2024, 1, 1),
      closingHour: DateTime.tryParse(json['closing_hour'] ?? '') ?? DateTime(2024, 1, 1),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'informations': informations,
      'opening_hour': openingHour.toIso8601String(),
      'closing_hour': closingHour.toIso8601String(),
    };
  }
}
