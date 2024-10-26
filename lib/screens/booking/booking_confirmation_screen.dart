import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../models/route.dart' as AppRoute;
import '../../models/ticket.dart';
import '../../services/ticket_service.dart';
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
              onPressed: () async {
                String userId = 'exampleUserId'; // Replace with actual user ID
                String vehicleId =
                    'exampleVehicleId'; // Replace with actual vehicle ID
                String passengerName =
                    'examplePassengerName'; // Replace with actual passenger name
                DateTime bookingDate = DateTime.now();
                DateTime travelDate = DateTime.now().add(Duration(days: 1));

                Ticket ticket = Ticket(
                  id: Uuid().v4(),
                  userId: userId,
                  routeId: route.id,
                  vehicleId: vehicleId,
                  seatNumber: seat.toString(),
                  bookingDate: bookingDate,
                  travelDate: travelDate,
                  passengerName: passengerName,
                );

                // Save ticket to Firestore
                await TicketService().createTicket(ticket);

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
