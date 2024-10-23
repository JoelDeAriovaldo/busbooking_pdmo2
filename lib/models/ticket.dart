class Ticket {
  final String id;
  final String userId;
  final String routeId;
  final String vehicleId;
  final String seatNumber;
  final DateTime bookingDate;
  final DateTime travelDate;
  final String passengerName;

  Ticket({
    required this.id,
    required this.userId,
    required this.routeId,
    required this.vehicleId,
    required this.seatNumber,
    required this.bookingDate,
    required this.travelDate,
    required this.passengerName,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['id'],
      userId: json['userId'],
      routeId: json['routeId'],
      vehicleId: json['vehicleId'],
      seatNumber: json['seatNumber'],
      bookingDate: DateTime.parse(json['bookingDate']),
      travelDate: DateTime.parse(json['travelDate']),
      passengerName: json['passengerName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'routeId': routeId,
      'vehicleId': vehicleId,
      'seatNumber': seatNumber,
      'bookingDate': bookingDate.toIso8601String(),
      'travelDate': travelDate.toIso8601String(),
      'passengerName': passengerName,
    };
  }
}
