class User {
  final String id;
  final String name;
  final String phoneNumber;
  final String email;
  final String password;
  final List<String> travelHistory;
  final String seatPreference;

  User({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.email,
    required this.password,
    required this.travelHistory,
    required this.seatPreference,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      password: json['password'],
      travelHistory: List<String>.from(json['travelHistory']),
      seatPreference: json['seatPreference'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phoneNumber': phoneNumber,
      'email': email,
      'password': password,
      'travelHistory': travelHistory,
      'seatPreference': seatPreference,
    };
  }
}
