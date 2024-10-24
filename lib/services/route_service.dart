import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/route.dart';

class RouteService {
  final CollectionReference routeCollection =
      FirebaseFirestore.instance.collection('routes');

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

  // Get all routes
  Future<List<Route>> getAllRoutes() async {
    try {
      QuerySnapshot querySnapshot = await routeCollection.get();
      return querySnapshot.docs
          .map((doc) => Route.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print(e.toString());
      return [];
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
}
