import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vehicle.dart';

class VehicleService {
  final CollectionReference vehicleCollection =
      FirebaseFirestore.instance.collection('vehicles');

  // Get vehicle by ID
  Future<Vehicle?> getVehicleById(String id) async {
    try {
      DocumentSnapshot doc = await vehicleCollection.doc(id).get();
      return Vehicle.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Get all vehicles
  Future<List<Vehicle>> getAllVehicles() async {
    try {
      QuerySnapshot querySnapshot = await vehicleCollection.get();
      return querySnapshot.docs
          .map((doc) => Vehicle.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
