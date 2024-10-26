import 'package:cloud_firestore/cloud_firestore.dart';

class Route {
  final String id;
  final String startLocation;
  final String endLocation;
  final int distanceKm;
  final int durationMinutes;
  final double price;
  final List<String> availableSchedules;
  final List<String> stops;
  final String amenities;

  Route({
    required this.id,
    required this.startLocation,
    required this.endLocation,
    required this.distanceKm,
    required this.durationMinutes,
    required this.price,
    required this.availableSchedules,
    required this.stops,
    required this.amenities,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startLocation': startLocation,
      'endLocation': endLocation,
      'distanceKm': distanceKm,
      'durationMinutes': durationMinutes,
      'price': price,
      'availableSchedules': availableSchedules,
      'stops': stops,
      'amenities': amenities,
    };
  }

  factory Route.fromJson(Map<String, dynamic> json) {
    return Route(
      id: json['id'],
      startLocation: json['startLocation'],
      endLocation: json['endLocation'],
      distanceKm: json['distanceKm'],
      durationMinutes: json['durationMinutes'],
      price: json['price'],
      availableSchedules: List<String>.from(json['availableSchedules'] ?? []),
      stops: List<String>.from(json['stops'] ?? []),
      amenities: json['amenities'] ?? '',
    );
  }

  Duration get duration => Duration(minutes: durationMinutes);
}
