import 'package:flutter/material.dart';
import '../../models/ticket.dart';
import '../../services/ticket_service.dart';
import '../../utils/constants.dart';

class TicketDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String ticketId =
        ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket Details'),
      ),
      body: FutureBuilder<Ticket?>(
        future: TicketService().getTicketById(ticketId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Ticket not found'));
          } else {
            Ticket ticket = snapshot.data!;
            return Padding(
              padding: Constants.defaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Passenger Name: ${ticket.passengerName}',
                      style: Constants.bodyTextStyle),
                  SizedBox(height: 8.0),
                  Text('Seat Number: ${ticket.seatNumber}',
                      style: Constants.bodyTextStyle),
                  SizedBox(height: 8.0),
                  Text('Booking Date: ${ticket.bookingDate}',
                      style: Constants.bodyTextStyle),
                  SizedBox(height: 8.0),
                  Text('Travel Date: ${ticket.travelDate}',
                      style: Constants.bodyTextStyle),
                  SizedBox(height: 8.0),
                  Text('Route ID: ${ticket.routeId}',
                      style: Constants.bodyTextStyle),
                  SizedBox(height: 8.0),
                  Text('Vehicle ID: ${ticket.vehicleId}',
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
