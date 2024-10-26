import 'package:cloud_firestore/cloud_firestore.dart';

class Vehicle {
  final String id;
  final String model;
  final int capacity;
  final String features;
  final String plateNumber;
  final String status;
  final DateTime maintenanceDate;
  final String? currentRouteId;

  Vehicle({
    required this.id,
    required this.model,
    required this.capacity,
    required this.features,
    required this.plateNumber,
    required this.status,
    required this.maintenanceDate,
    this.currentRouteId,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] ?? '',
      model: json['model'] ?? '',
      capacity: json['capacity'] ?? 0,
      features: json['features'] ?? '',
      plateNumber: json['plateNumber'] ?? '',
      status: json['status'] ?? 'inactive',
      maintenanceDate: (json['maintenanceDate'] as Timestamp).toDate(),
      currentRouteId: json['currentRouteId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'model': model,
      'capacity': capacity,
      'features': features,
      'plateNumber': plateNumber,
      'status': status,
      'maintenanceDate': Timestamp.fromDate(maintenanceDate),
      'currentRouteId': currentRouteId,
    };
  }
}
