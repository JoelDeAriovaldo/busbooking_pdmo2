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
  Set<int> _selectedSeats = {};
  List<int> _bookedSeats = [1, 2, 5, 8];

  @override
  Widget build(BuildContext context) {
    // Safely get and validate route argument
    final arguments = ModalRoute.of(context)?.settings.arguments;
    final AppRoute.Route? route =
        arguments is AppRoute.Route ? arguments : null;

    if (route == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Invalid route information'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Seats'),
      ),
      body: SingleChildScrollView(
        padding: Constants.defaultPadding,
        child: Column(
          children: [
            Text('Route: ${route.startLocation} to ${route.endLocation}'),
            SizedBox(height: 16.0),
            SeatLayout(
              rows: 5,
              columns: 4,
              bookedSeats: _bookedSeats,
              selectedSeats: _selectedSeats,
              onSeatSelected: _onSeatSelected,
            ),
            SizedBox(height: 16.0),
            Text('Selected Seats: ${_selectedSeats.join(", ")}'),
            SizedBox(height: 16.0),
            CustomButton(
              text: 'Continue',
              onPressed: _selectedSeats.isEmpty
                  ? () {} // Provide a default no-op function
                  : () {
                      final List<int> selectedSeatsList =
                          _selectedSeats.toList();
                      if (selectedSeatsList.length > 1) {
                        Navigator.pushNamed(
                          context,
                          '/passengerDetails',
                          arguments: {
                            'route': route,
                            'seats': selectedSeatsList,
                          },
                        );
                      } else {
                        Navigator.pushNamed(
                          context,
                          '/bookingConfirmation',
                          arguments: {
                            'route': route,
                            'seats': selectedSeatsList,
                            'seat': selectedSeatsList[0],
                          },
                        );
                      }
                    },
            ),
          ],
        ),
      ),
    );
  }

  void _onSeatSelected(int seat) {
    setState(() {
      if (_selectedSeats.contains(seat)) {
        _selectedSeats.remove(seat);
      } else {
        _selectedSeats.add(seat);
      }
    });
  }
}
