import 'package:flutter/material.dart';
import '../../models/route.dart' as AppRoute;
import '../../services/route_service.dart';
import '../../utils/constants.dart';

class RouteDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String routeId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('Route Details'),
      ),
      body: FutureBuilder<AppRoute.Route?>(
        future: RouteService().getRouteById(routeId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Route not found'));
          } else {
            AppRoute.Route route = snapshot.data!;
            return Padding(
              padding: Constants.defaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Start Location: ${route.startLocation}',
                      style: Constants.bodyTextStyle),
                  SizedBox(height: 8.0),
                  Text('End Location: ${route.endLocation}',
                      style: Constants.bodyTextStyle),
                  SizedBox(height: 8.0),
                  Text('Stops: ${route.stops.join(', ')}',
                      style: Constants.bodyTextStyle),
                  SizedBox(height: 8.0),
                  Text(
                      'Duration: ${route.duration.inHours}h ${route.duration.inMinutes % 60}m',
                      style: Constants.bodyTextStyle),
                  SizedBox(height: 8.0),
                  Text('Amenities: ${route.amenities}',
                      style: Constants.bodyTextStyle),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
