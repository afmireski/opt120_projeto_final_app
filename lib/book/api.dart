import 'package:dio/dio.dart';
import 'package:produto_front/config/config.dart';
import 'package:produto_front/stores/user-store.dart';

import 'entities.dart';

// Constants
const String baseURL = Config.baseUrl;

final dio = Dio();

String? get token => UserStore().token;

Future<List<Room>?> listRooms() async {
  Response resp = await dio.get(
    '$baseURL/api/rooms',
    options: Options(
      headers: {
        'Authorization': token,
      },
    ),
  );
  List data = resp.data['data'];
  List<Room> rooms = List.castFrom(data
      .map(
        (e) => Room(
          id: e['id'],
          name: e['name'],
          informations: e['informations'],
          openingHour: e['opening_hour'],
          closingHour: e['closing_hour'],
        ),
      )
      .toList());
  return rooms;
}

Future<List<TimeSlot>?> listTimeSlotsFromRoom(Room room) async {
  Response resp = await dio.get(
    '$baseURL/api/rooms/${room.id}',
    options: Options(
      headers: {
        'Authorization': token,
      },
    ),
  );
  List hoursRaw = resp.data['hours'];
  print(hoursRaw);
  List<TimeSlot> hours = List.castFrom(hoursRaw
      .map(
        (e) => TimeSlot(
          id: e['id'],
          openingHour: e['opening'],
          closingHour: e['closing'],
          weekDay: e['week_day'],
        ),
      )
      .toList());
  return hours;
}

Future<void> book(Booking booking) async {
  print('Booking....');
  print(booking.timeSlot!.weekDay);
  print(booking.date!.weekday);
  Response resp = await dio.post('$baseURL/api/bookings/new-intent',
      options: Options(
        headers: {
          'Authorization': token,
        },
      ),
      data: {
        'room_id': booking.room!.id,
        'hour_id': booking.timeSlot!.id,
        'date':
            '${booking.date!.year.toString().padLeft(4, '0')}-${booking.date!.month.toString().padLeft(2, '0')}-${booking.date!.day.toString().padLeft(2, '0')}',
      });
  print('Finished!');
  print(resp.data);
  print(resp.statusCode);
}
