import 'package:flutter/material.dart';
import '../../models/vehicle.dart';
import '../../services/vehicle_service.dart';
import '../../utils/constants.dart';

class VehicleInfoScreen extends StatelessWidget {
  final VehicleService _vehicleService = VehicleService();

  @override
  Widget build(BuildContext context) {
    final String vehicleId =
        ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Info'),
      ),
      body: FutureBuilder<Vehicle?>(
        future: _vehicleService.getVehicleById(vehicleId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Vehicle not found'));
          } else {
            Vehicle vehicle = snapshot.data!;
            return Padding(
              padding: Constants.defaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Model: ${vehicle.model}',
                      style: Constants.bodyTextStyle),
                  SizedBox(height: 8.0),
                  Text('Capacity: ${vehicle.capacity}',
                      style: Constants.bodyTextStyle),
                  SizedBox(height: 8.0),
                  Text('Features: ${vehicle.features}',
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
