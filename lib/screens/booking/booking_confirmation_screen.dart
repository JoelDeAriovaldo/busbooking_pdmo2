import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
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
          title: Text('Erro'),
        ),
        body: Center(
          child: Text('Nenhuma informação de reserva fornecida'),
        ),
      );
    }

    final AppRoute.Route route = args['route'];
    final int? seat = args['seat'] as int?;
    if (seat == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Erro'),
        ),
        body: Center(
          child: Text('Nenhuma informação de assento fornecida'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Constants.surfaceColor,
        leading: IconButton(
          icon: Icon(LucideIcons.arrowLeft, color: Constants.textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Confirmação de Reserva',
          style: TextStyle(
              color: Constants.textColor, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: Constants.defaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Constants.borderRadius),
                side: BorderSide(color: Constants.surfaceColor),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Constants.borderRadius),
                  gradient: LinearGradient(
                    colors: [Constants.primaryColor, Constants.secondaryColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(LucideIcons.mapPin,
                              size: 20, color: Constants.textColor),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              '${route.startLocation} → ${route.endLocation}',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Constants.textColor),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(LucideIcons.armchair,
                              size: 20, color: Constants.textColor),
                          SizedBox(width: 12),
                          Text(
                            'Número do Assento: $seat',
                            style: TextStyle(color: Constants.textColor),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.0),
            CustomButton(
              text: 'Confirmar Reserva',
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
