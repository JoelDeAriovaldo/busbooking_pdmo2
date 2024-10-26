import 'package:flutter/material.dart';
import '../../models/route.dart' as AppRoute;
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';

class BookingConfirmationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic>? args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('No booking information provided'),
        ),
      );
    }

    final AppRoute.Route route = args['route'];
    final int? seat = args['seat'] as int?;
    if (seat == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('No seat information provided'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Confirmation'),
      ),
      body: Padding(
        padding: Constants.defaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Route: ${route.startLocation} to ${route.endLocation}'),
            SizedBox(height: 8.0),
            Text('Seat Number: $seat'),
            SizedBox(height: 16.0),
            CustomButton(
              text: 'Confirm Booking',
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/payment',
                  arguments: {
                    'route': route,
                    'seats': [seat],
                    'passengers':
                        <Map<String, String>>[], // Ensure correct typing
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
