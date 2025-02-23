import 'package:flutter/material.dart';

class BookingRequests extends StatefulWidget {
  const BookingRequests({super.key});

  @override
  _BookingRequestsState createState() => _BookingRequestsState();
}

class _BookingRequestsState extends State<BookingRequests> {
  List<Map<String, dynamic>> _mockBookings = [
    {
      "id": 1,
      "room": {"name": "Sala A"},
      "hour": {"opening": "10:00", "closing": "11:00"},
      "user": {"name": "Student"},
      "state": "PENDING",
      "created_at": "2025-03-10",
    },
    {
      "id": 2,
      "room": {"name": "Sala B"},
      "hour": {"opening": "14:00", "closing": "15:00"},
      "user": {"name": "Servent"},
      "state": "PENDING",
      "created_at": "2025-03-11",
    },
    {
      "id": 3,
      "room": {"name": "Sala C"},
      "hour": {"opening": "09:00", "closing": "10:00"},
      "user": {"name": "Professor"},
      "state": "CANCELED",
      "created_at": "2025-03-12",
    },
  ];

  String _filterName = "";
  DateTime? _filterDate;

  void _showConfirmationDialog(String action) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('$action Reserva'),
          content: Text('Deseja realmente $action esta reserva?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(action),
            ),
          ],
        );
      },
    );
  }

  String getSafeValue(Map<String, dynamic>? data, String key, {String defaultValue = "Desconhecido"}) {
    return data != null && data[key] != null ? data[key].toString() : defaultValue;
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredBookings = _mockBookings.where((booking) {
      bool matchesName = _filterName.isEmpty || getSafeValue(booking["room"], "name").toLowerCase().contains(_filterName.toLowerCase());
      bool matchesDate = _filterDate == null || booking["created_at"] == _filterDate!.toIso8601String().split("T")[0];
      return matchesName && matchesDate;
    }).toList();

    filteredBookings.sort((a, b) => a["state"] == "PENDING" ? -1 : 1);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(labelText: "Filtrar por nome da sala"),
                    onChanged: (value) => setState(() => _filterName = value),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2024),
                      lastDate: DateTime(2026),
                    );
                    if (pickedDate != null) {
                      setState(() => _filterDate = pickedDate);
                    }
                  },
                  child: const Text("Selecionar Data"),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey.shade200,
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: filteredBookings.length,
                itemBuilder: (context, index) {
                  final booking = filteredBookings[index];
                  Color statusColor;

                  switch (booking["state"]) {
                    case "PENDING":
                      statusColor = Colors.amber;
                      break;
                    case "APPROVED":
                      statusColor = Colors.green;
                      break;
                    case "REJECTED":
                    case "CANCELED":
                      statusColor = Colors.red;
                      break;
                    default:
                      statusColor = Colors.grey;
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${getSafeValue(booking["user"], "name")} - ${getSafeValue(booking["room"], "name")}",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text("Horário: ${getSafeValue(booking["hour"], "opening")} - ${getSafeValue(booking["hour"], "closing")}"),
                          Text("Data: ${getSafeValue(booking, "created_at")}"),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(booking["state"].toUpperCase()),
                              const Spacer(),
                              if (booking["state"] != "CANCELED") ...[
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                                  onPressed: () => _showConfirmationDialog("Aprovar"),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.check, color: Colors.black),
                                      SizedBox(width: 4),
                                      Text("Aprovar", style: TextStyle(color: Colors.black)),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                  onPressed: () => _showConfirmationDialog("Rejeitar"),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.close, color: Colors.white),
                                      SizedBox(width: 4),
                                      Text("Rejeitar", style: TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
