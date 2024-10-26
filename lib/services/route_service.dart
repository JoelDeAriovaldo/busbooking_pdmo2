import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/route.dart';
import '../models/vehicle.dart';
import 'vehicle_service.dart';

class RouteService {
  final CollectionReference routeCollection =
      FirebaseFirestore.instance.collection('routes');
  final VehicleService _vehicleService = VehicleService();

  // Fetch all unique start locations
  Future<List<String>> getStartLocations() async {
    try {
      QuerySnapshot querySnapshot = await routeCollection.get();
      Set<String> startLocations = querySnapshot.docs
          .map((doc) => doc['startLocation'] as String)
          .toSet();
      return startLocations.toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  // Fetch all unique end locations for a given start location
  Future<List<String>> getEndLocations(String startLocation) async {
    try {
      QuerySnapshot querySnapshot = await routeCollection
          .where('startLocation', isEqualTo: startLocation)
          .get();
      Set<String> endLocations =
          querySnapshot.docs.map((doc) => doc['endLocation'] as String).toSet();
      return endLocations.toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  // Search routes by start and end location
  Future<List<Route>> searchRoutes(
      String startLocation, String endLocation) async {
    try {
      QuerySnapshot querySnapshot = await routeCollection
          .where('startLocation', isEqualTo: startLocation)
          .where('endLocation', isEqualTo: endLocation)
          .get();
      return querySnapshot.docs
          .map((doc) => Route.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  // Get available schedules for a specific route and date
  Future<List<String>> getAvailableSchedules(
      String routeId, String date) async {
    try {
      DocumentSnapshot doc = await routeCollection.doc(routeId).get();
      if (doc.exists && doc.data() != null) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('schedules')) {
          return List<String>.from(data['schedules']);
        }
      }
      return [];
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  // Get distance and time between two points
  Future<Map<String, dynamic>?> getDistanceAndTime(
      String startLocation, String endLocation) async {
    try {
      QuerySnapshot querySnapshot = await routeCollection
          .where('startLocation', isEqualTo: startLocation)
          .where('endLocation', isEqualTo: endLocation)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data.containsKey('distance') && data.containsKey('time')) {
          return {
            'distance': data['distance'],
            'time': data['time'],
          };
        }
      }
      return null;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Get route by ID
  Future<Route?> getRouteById(String id) async {
    try {
      DocumentSnapshot doc = await routeCollection.doc(id).get();
      return Route.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Get route with available vehicles
  Future<Map<String, dynamic>> getRouteWithVehicles(String routeId) async {
    try {
      DocumentSnapshot routeDoc = await routeCollection.doc(routeId).get();
      if (!routeDoc.exists) {
        throw Exception('Route not found');
      }

      Route route = Route.fromJson(routeDoc.data() as Map<String, dynamic>);
      List<Vehicle> vehicles =
          await _vehicleService.getVehiclesByRoute(routeId);

      return {
        'route': route,
        'vehicles': vehicles,
      };
    } catch (e) {
      print('Error getting route with vehicles: $e');
      throw e;
    }
  }

  // Assign vehicle to route
  Future<void> assignVehicleToRoute(String routeId, String vehicleId) async {
    try {
      // Start a transaction to ensure data consistency
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        // Get current route data
        DocumentSnapshot routeDoc =
            await transaction.get(routeCollection.doc(routeId));
        List<String> assignedVehicles =
            List<String>.from(routeDoc['assignedVehicles'] ?? []);

        // Add vehicle if not already assigned
        if (!assignedVehicles.contains(vehicleId)) {
          assignedVehicles.add(vehicleId);

          // Update route document
          transaction.update(routeCollection.doc(routeId), {
            'assignedVehicles': assignedVehicles,
          });

          // Update vehicle document
          transaction.update(_vehicleService.vehicleCollection.doc(vehicleId), {
            'currentRouteId': routeId,
          });
        }
      });
    } catch (e) {
      print('Error assigning vehicle to route: $e');
      throw e;
    }
  }
}
