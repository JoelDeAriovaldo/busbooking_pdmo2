import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/route.dart';

class RouteService {
  final CollectionReference routeCollection =
      FirebaseFirestore.instance.collection('routes');

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
      final data = doc.data() as Map<String, dynamic>?;
      if (doc.exists && data != null && data.containsKey('schedules')) {
        List<String> schedules = List<String>.from(data['schedules']);
        return schedules;
      } else {
        return [];
      }
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
        final data = doc.data() as Map<String, dynamic>?;
        return {
          'distance': data != null && data.containsKey('distance')
              ? data['distance']
              : null,
          'time':
              data != null && data.containsKey('time') ? data['time'] : null,
        };
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Get route by ID
  Future<Route?> getRouteById(String id) async {
    try {
      DocumentSnapshot doc = await routeCollection.doc(id).get();
      final data = doc.data() as Map<String, dynamic>?;
      if (data != null) {
        return Route.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
