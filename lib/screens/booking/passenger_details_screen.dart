import 'package:flutter/material.dart';
import '../../models/route.dart' as AppRoute;
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class PassengerDetailsScreen extends StatefulWidget {
  @override
  _PassengerDetailsScreenState createState() => _PassengerDetailsScreenState();
}

class _PassengerDetailsScreenState extends State<PassengerDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  late List<Map<String, TextEditingController>> _passengersControllers;

  @override
  void initState() {
    super.initState();
    _passengersControllers = [];
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is! Map<String, dynamic>) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Invalid passenger information'),
        ),
      );
    }

    final route = args['route'] as AppRoute.Route?;
    final seats = args['seats'] as List<int>?;

    if (route == null || seats == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Missing route or seat information'),
        ),
      );
    }

    if (_passengersControllers.isEmpty) {
      for (int i = 0; i < seats.length; i++) {
        // Start from 0 to include all seats
        _passengersControllers.add({
          'name': TextEditingController(),
          'phone': TextEditingController(),
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Passenger Details'),
      ),
      body: SingleChildScrollView(
        padding: Constants.defaultPadding,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Route: ${route.startLocation} to ${route.endLocation}'),
              SizedBox(height: 16.0),
              Text('Selected Seats: ${seats.join(", ")}'),
              SizedBox(height: 24.0),
              ..._buildPassengerForms(seats),
              SizedBox(height: 24.0),
              CustomButton(
                text: 'Continue to Payment',
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    List<Map<String, String>> passengers = [];
                    for (var controller in _passengersControllers) {
                      passengers.add({
                        'name': controller['name']!.text,
                        'phone': controller['phone']!.text,
                      });
                    }

                    Navigator.pushNamed(
                      context,
                      '/payment',
                      arguments: {
                        'route': route,
                        'seats': seats,
                        'passengers': passengers,
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPassengerForms(List<int> seats) {
    List<Widget> forms = [];
    for (int i = 1; i < seats.length; i++) {
      forms.addAll([
        Text('Passenger ${i + 1} (Seat ${seats[i]})',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8.0),
        CustomTextField(
          labelText: 'Full Name',
          controller: _passengersControllers[i - 1]['name']!,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter passenger name';
            }
            return null;
          },
        ),
        SizedBox(height: 8.0),
        CustomTextField(
          labelText: 'Phone Number',
          controller: _passengersControllers[i - 1]['phone']!,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter phone number';
            }
            return null;
          },
        ),
        SizedBox(height: 16.0),
      ]);
    }
    return forms;
  }

  @override
  void dispose() {
    for (var controller in _passengersControllers) {
      controller['name']!.dispose();
      controller['phone']!.dispose();
    }
    super.dispose();
  }
}
