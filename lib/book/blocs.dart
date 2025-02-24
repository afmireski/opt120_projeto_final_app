import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'api.dart';
import 'entities.dart';

// Abstract classes ------------------------------------
abstract class RoomListState {}

abstract class TimeSlotListState {}

abstract class BookState {}

abstract class RoomListEvent {}

abstract class TimeSlotListEvent {}

abstract class BookEvent {}

// -----------------------------------------------------

// RoomListState ---------------------------------------
class RoomListSuccessful extends RoomListState {
  final List<Room> rooms;
  RoomListSuccessful(this.rooms);
}

class RoomListError extends RoomListState {
  String errorMessage;
  RoomListError(this.errorMessage);
}

class RoomListZero extends RoomListState {}

class RoomListLoading extends RoomListState {}

// RoomListState ---------------------------------------
class ListRooms extends RoomListEvent {}

// -----------------------------------------------------

// -----------------------------------------------------

// TimeSlotListState -----------------------------------
class TimeSlotListSuccessful extends TimeSlotListState {
  final List<TimeSlot> slots;
  TimeSlotListSuccessful(this.slots);
}

class TimeSlotListError extends TimeSlotListState {
  String errorMessage;
  TimeSlotListError(this.errorMessage);
}

class TimeSlotListZero extends TimeSlotListState {}

class TimeSlotListLoading extends TimeSlotListState {}

// TimeSlotListEvent ---------------------------------------
class ListTimeSlots extends TimeSlotListEvent {
  final Room room;
  ListTimeSlots(this.room);
}

// -----------------------------------------------------

// BookState -----------------------------------
class BookSuccessful extends BookState {
  BookSuccessful();
}

class BookError extends BookState {
  String errorMessage;
  BookError(this.errorMessage);
}

class BookZero extends BookState {}

class BookLoading extends BookState {}

// BookEvent ---------------------------------------
class Book extends BookEvent {
  final Booking booking;
  Book(this.booking);
}

class BookReset extends BookEvent {
  BookReset();
}

// ------------------------------------------------

// RoomListBloc ---------------------------------------

class RoomListBloc extends Bloc<RoomListEvent, RoomListState> {
  RoomListBloc() : super(RoomListZero()) {
    on<ListRooms>((event, emit) async {
      try {
        emit(RoomListLoading());
        List<Room>? rooms = await listRooms();
        if (rooms != null) {
          emit(RoomListSuccessful(rooms));
        }
      } catch (err) {
        emit(RoomListError(err.toString()));
      }
    });
  }
}

// ------------------------------------------------

// TimeSlotListBloc ---------------------------------------

class TimeSlotListBloc extends Bloc<TimeSlotListEvent, TimeSlotListState> {
  TimeSlotListBloc() : super(TimeSlotListZero()) {
    on<ListTimeSlots>((event, emit) async {
      try {
        emit(TimeSlotListLoading());
        List<TimeSlot>? slots = await listTimeSlotsFromRoom(event.room);
        if (slots != null) {
          emit(TimeSlotListSuccessful(slots));
        }
      } catch (err) {
        emit(TimeSlotListError(err.toString()));
      }
    });
  }
}

// ------------------------------------------------

// BookBloc ---------------------------------------

class BookBloc extends Bloc<BookEvent, BookState> {
  BookBloc() : super(BookZero()) {
    on<Book>((event, emit) async {
      try {
        emit(BookLoading());
        await book(event.booking);
        emit(BookSuccessful());
      } catch (err) {
        print(err);
        if (err is DioException) {
          print(err.response!.data);
        }
        emit(BookError(err.toString()));
      }
    });
    on<BookReset>((event, emit) async {
      emit(BookZero());
    });
  }
}
