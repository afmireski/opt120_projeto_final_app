import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:produto_front/book/data.dart';
import 'blocs.dart';
import 'entities.dart';

const titleStyle = TextStyle(fontSize: 20);

class BookForm extends StatefulWidget {
  const BookForm({super.key});

  @override
  State<BookForm> createState() => _BookForm();
}

class _BookForm extends State<BookForm> {
  int stackIndex = 0;
  Room? selectedRoom;
  TimeSlot? selectedSlot;
  DateTime? selectedDate;
  int selectedWeekday = (DateTime.now().weekday % 7) + 1;
  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: [
          BlocProvider<RoomListBloc>(
              create: (_) => RoomListBloc()..add(ListRooms())),
          BlocProvider<TimeSlotListBloc>(create: (_) => TimeSlotListBloc()),
          BlocProvider<BookBloc>(create: (_) => BookBloc()),
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<TimeSlotListBloc, TimeSlotListState>(
                listener: (context, state) {
              if (state is TimeSlotListSuccessful) {
                if (state.slots.isNotEmpty) {
                  List<int> availableWeekDays =
                      state.slots.map((e) => e.weekDay!).toList();
                  availableWeekDays.sort();
                  int minWeekDay = availableWeekDays[0];
                  setState(() {
                    selectedWeekday = minWeekDay;
                  });
                }
              }
            }),
            BlocListener<BookBloc, BookState>(
              listener: (context, state) {
                if (state is BookSuccessful) {
                  setState(() {
                    stackIndex = 3;
                  });
                } else if (state is BookError) {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            title: const Text(
                              'Não é possível reservar nessa sala, dia e horário',
                              style: TextStyle(color: Colors.white),
                            ),
                            content: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Ok'),
                            ),
                            backgroundColor: Colors.red,
                          ));
                }
              },
            ),
          ],
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  title,
                  style: titleStyle,
                ),
              ),
              divider,
              Expanded(
                child: IndexedStack(
                  index: stackIndex,
                  children: [
                    BlocBuilder<RoomListBloc, RoomListState>(
                      builder: (context, state) {
                        if (state is RoomListSuccessful) {
                          return ListView(
                            children: state.rooms
                                .map(
                                  (e) => RadioListTile<int>(
                                    groupValue: selectedRoomId,
                                    onChanged: (b) {
                                      if (selectedRoom != e) {
                                        setState(() {
                                          selectedRoom = e;
                                          selectedSlot = null;
                                          context
                                              .read<TimeSlotListBloc>()
                                              .add(ListTimeSlots(e));
                                        });
                                      }
                                    },
                                    value: e.id ?? -1,
                                    title: Text(e.name ?? ''),
                                  ),
                                )
                                .toList(),
                          );
                        }
                        if (state is RoomListLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (state is RoomListError) {
                          return Center(child: Text(state.errorMessage));
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                    Column(
                      children: [
                        Expanded(
                          child:
                              BlocBuilder<TimeSlotListBloc, TimeSlotListState>(
                            builder: (context, state) {
                              if (state is TimeSlotListSuccessful) {
                                List<TimeSlot> weekDaySlots = state.slots
                                    .where((slot) =>
                                        slot.weekDay == selectedWeekday)
                                    .toList();
                                if (weekDaySlots.isEmpty) {
                                  return const Center(
                                    child: Text(
                                        'Sem horários nesse dia da semana'),
                                  );
                                }
                                return ListView(
                                  children: weekDaySlots
                                      .map(
                                        (e) => RadioListTile<int>(
                                          groupValue: selectedSlotId,
                                          onChanged: (b) {
                                            if (selectedSlot != e) {
                                              setState(() {
                                                selectedSlot = e;
                                                selectedDate = null;
                                              });
                                            }
                                          },
                                          value: e.id ?? -1,
                                          title: Text(
                                              '${e.openingHour} - ${e.closingHour}'),
                                        ),
                                      )
                                      .toList(),
                                );
                              }
                              if (state is TimeSlotListLoading) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              if (state is TimeSlotListError) {
                                return Center(child: Text(state.errorMessage));
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                        divider,
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: ColoredBox(
                              color: Colors.black,
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: selectedWeekday == 1
                                        ? null
                                        : () {
                                            setState(() {
                                              selectedSlot = null;
                                              selectedWeekday--;
                                            });
                                          },
                                    icon: const Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Expanded(
                                      child: Text(
                                    weekDays[selectedWeekday - 1],
                                    style: const TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  )),
                                  IconButton(
                                    onPressed: selectedWeekday == 7
                                        ? null
                                        : () {
                                            setState(() {
                                              selectedSlot = null;
                                              selectedWeekday++;
                                            });
                                          },
                                    icon: const Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    BlocBuilder<BookBloc, BookState>(
                      builder: (context, state) => Center(
                        child: ElevatedButton.icon(
                          icon: const Icon(
                            Icons.calendar_month,
                            color: Colors.white,
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              selectableDayPredicate: (day) =>
                                  ((day.weekday % 7) + 1) == selectedWeekday,
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(
                                const Duration(days: 90),
                              ),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                selectedDate = pickedDate;
                              });
                            }
                          },
                          label: Text(datePickerButtonText),
                        ),
                      ),
                    ),
                    const Center(
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 100,
                      ),
                    )
                  ],
                ),
              ),
              divider,
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: ((stackIndex != 0) && (stackIndex != 3))
                          ? () {
                              setState(() {
                                stackIndex--;
                              });
                            }
                          : null,
                      child: const Text('Voltar'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: advanceButton,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  int get selectedRoomId {
    if (selectedRoom != null) {
      return selectedRoom!.id!;
    }
    return -1;
  }

  int get selectedSlotId {
    if (selectedSlot != null) {
      return selectedSlot!.id!;
    }
    return -1;
  }

  bool get canAdvance {
    if (stackIndex == 0) {
      return selectedRoom != null;
    }
    if (stackIndex == 1) {
      return selectedSlot != null;
    }
    return selectedDate != null;
  }

  String get title {
    return [
      'Selecione a sala para reservar',
      'Selecione o horário da reserva',
      'Selecione o dia da reserva',
      'Reserva pedida com sucesso!',
    ][stackIndex];
  }

  String get datePickerButtonText {
    if (selectedDate != null) {
      return '${selectedDate!.day} de ${months[selectedDate!.month]} de ${selectedDate!.year}';
    }
    return 'Selecionar dia';
  }

  Widget get advanceButton {
    if (stackIndex == 2) {
      return BlocBuilder<BookBloc, BookState>(builder: (context, state) {
        print(state);
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
          ),
          onPressed: canAdvance && state is! BookLoading
              ? () {
                  context.read<BookBloc>().add(
                        Book(
                          Booking(
                            date: selectedDate,
                            room: selectedRoom,
                            timeSlot: selectedSlot,
                          ),
                        ),
                      );
                }
              : null,
          child: (state is BookLoading)
              ? const SizedBox(
                  width: 20, height: 20, child: CircularProgressIndicator())
              : const Text('Checar e enviar'),
        );
      });
    }
    if (stackIndex == 3) {
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        onPressed: canAdvance
            ? () {
                setState(() {
                  Navigator.of(context).pop();
                });
              }
            : null,
        child: const Text('Voltar ao início'),
      );
    }
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      onPressed: canAdvance
          ? () {
              setState(() {
                stackIndex++;
              });
            }
          : null,
      child: const Text('Próximo'),
    );
  }

  final divider = const Divider(
    color: Color.fromARGB(32, 0, 0, 0),
    indent: 0,
    endIndent: 0,
    thickness: 2,
    height: 2,
  );
}
