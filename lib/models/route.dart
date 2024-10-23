class Route {
  final String id;
  final String startLocation;
  final String endLocation;
  final List<String> stops;
  final Duration duration;
  final String amenities;

  Route({
    required this.id,
    required this.startLocation,
    required this.endLocation,
    required this.stops,
    required this.duration,
    required this.amenities,
  });

  factory Route.fromJson(Map<String, dynamic> json) {
    return Route(
      id: json['id'],
      startLocation: json['startLocation'],
      endLocation: json['endLocation'],
      stops: List<String>.from(json['stops']),
      duration: Duration(minutes: json['duration']),
      amenities: json['amenities'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startLocation': startLocation,
      'endLocation': endLocation,
      'stops': stops,
      'duration': duration.inMinutes,
      'amenities': amenities,
    };
  }
}
