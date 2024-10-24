import 'package:flutter/material.dart';
import '../../models/route.dart' as AppRoute;
import '../../widgets/seat_layout.dart';
import '../../widgets/custom_button.dart';
import '../../utils/constants.dart';

class SeatSelectionScreen extends StatefulWidget {
  @override
  _SeatSelectionScreenState createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  int? _selectedSeat;
  List<int> _bookedSeats = [1, 2, 5, 8]; // Example booked seats

  void _onSeatSelected(int seat) {
    setState(() {
      _selectedSeat = seat;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppRoute.Route route =
        ModalRoute.of(context)!.settings.arguments as AppRoute.Route;

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Seat'),
      ),
      body: Padding(
        padding: Constants.defaultPadding,
        child: Column(
          children: [
            Text('Route: ${route.startLocation} to ${route.endLocation}'),
            SizedBox(height: 16.0),
            SeatLayout(
              rows: 5,
              columns: 4,
              bookedSeats: _bookedSeats,
              onSeatSelected: _onSeatSelected,
            ),
            SizedBox(height: 16.0),
            CustomButton(
              text: 'Confirm',
              onPressed: _selectedSeat != null
                  ? () {
                      Navigator.pushNamed(context, '/bookingConfirmation',
                          arguments: {
                            'route': route,
                            'seat': _selectedSeat,
                          });
                    }
                  : () {}, // Provide a no-op function when _selectedSeat is null
            ),
          ],
        ),
      ),
    );
  }
}
