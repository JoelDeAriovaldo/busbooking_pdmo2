class Vehicle {
  final String id;
  final String model;
  final int capacity;
  final String features;

  Vehicle({
    required this.id,
    required this.model,
    required this.capacity,
    required this.features,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'],
      model: json['model'],
      capacity: json['capacity'],
      features: json['features'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'model': model,
      'capacity': capacity,
      'features': features,
    };
  }
}
