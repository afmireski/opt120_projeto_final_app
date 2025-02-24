class Room {
  int? id;
  String? name;
  String? openingHour;
  String? closingHour;
  Map<String, dynamic> informations;
  Room(
      {this.id,
      this.name,
      this.closingHour,
      this.informations = const {},
      this.openingHour});
}

class TimeSlot {
  int? id;
  int? weekDay;
  String? openingHour;
  String? closingHour;
  TimeSlot({this.id, this.closingHour, this.openingHour, this.weekDay});
}

class Booking {
  int? id;
  Room? room;
  TimeSlot? timeSlot;
  DateTime? date;
  Booking({this.id, this.room, this.date, this.timeSlot});
}
