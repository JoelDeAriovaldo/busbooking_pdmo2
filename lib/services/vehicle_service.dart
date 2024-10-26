import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/vehicle.dart';

class VehicleService {
  final CollectionReference vehicleCollection =
      FirebaseFirestore.instance.collection('vehicles');

  // Create new vehicle
  Future<void> createVehicle(Vehicle vehicle) async {
    try {
      await vehicleCollection.doc(vehicle.id).set(vehicle.toJson());
    } catch (e) {
      print('Error creating vehicle: $e');
      throw e;
    }
  }

  // Get vehicle by ID
  Future<Vehicle?> getVehicleById(String id) async {
    try {
      DocumentSnapshot doc = await vehicleCollection.doc(id).get();
      if (doc.exists) {
        return Vehicle.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Error getting vehicle: $e');
      throw e;
    }
  }

  // Get vehicles for a specific route
  Future<List<Vehicle>> getVehiclesByRoute(String routeId) async {
    try {
      QuerySnapshot querySnapshot = await vehicleCollection
          .where('currentRouteId', isEqualTo: routeId)
          .where('status', isEqualTo: 'active')
          .get();

      return querySnapshot.docs
          .map((doc) => Vehicle.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting vehicles by route: $e');
      throw e;
    }
  }

  // Update vehicle status
  Future<void> updateVehicleStatus(String vehicleId, String status) async {
    try {
      await vehicleCollection.doc(vehicleId).update({'status': status});
    } catch (e) {
      print('Error updating vehicle status: $e');
      throw e;
    }
  }

  // Assign vehicle to route
  Future<void> assignVehicleToRoute(String vehicleId, String routeId) async {
    try {
      await vehicleCollection
          .doc(vehicleId)
          .update({'currentRouteId': routeId});
    } catch (e) {
      print('Error assigning vehicle to route: $e');
      throw e;
    }
  }
}
