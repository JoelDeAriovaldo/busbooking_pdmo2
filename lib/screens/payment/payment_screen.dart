import 'package:flutter/material.dart';
import '../../services/payment_service.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../../models/route.dart' as AppRoute;

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final PaymentService _paymentService = PaymentService();
  String? _selectedWallet;
  final List<String> _wallets = ['MPesa', 'Emola', 'Mkesh'];
  final TextEditingController _phoneController = TextEditingController();

  void _processPayment(double amount) async {
    if (_selectedWallet != null && _phoneController.text.isNotEmpty) {
      String userId = 'exampleUserId';

      try {
        await _paymentService.processPayment(userId, amount, _selectedWallet!);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment processed successfully')),
        );

        // Navigate to MyTicketsScreen
        Navigator.pushReplacementNamed(context, '/myTickets');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed: ${e.toString()}')),
        );
      }
    }
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
          child: Text('Invalid payment information'),
        ),
      );
    }

    final route = args['route'] as AppRoute.Route?;
    final List<Map<String, String>>? passengers =
        args['passengers'] as List<Map<String, String>>?;
    final List<int>? seats = args['seats'] as List<int>?;
    if (seats == null || seats.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('No seat information provided'),
        ),
      );
    }

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

    final double totalAmount = route.price * seats.length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: SingleChildScrollView(
        padding: Constants.defaultPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Route: ${route.startLocation} to ${route.endLocation}'),
            SizedBox(height: 8.0),
            Text('Selected Seats: ${seats.join(", ")}'),
            SizedBox(height: 8.0),
            Text('Total Amount: \$${totalAmount.toStringAsFixed(2)}'),
            SizedBox(height: 24.0),
            Text('Select Payment Method:'),
            SizedBox(height: 16.0),
            ..._wallets.map((wallet) => RadioListTile<String>(
                  title: Text(wallet),
                  value: wallet,
                  groupValue: _selectedWallet,
                  onChanged: (value) {
                    setState(() {
                      _selectedWallet = value;
                    });
                  },
                )),
            if (_selectedWallet != null) ...[
              SizedBox(height: 16.0),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Mozambique Phone Number',
                  hintText: 'Enter your phone number',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
            SizedBox(height: 24.0),
            CustomButton(
              text: 'Pay Now',
              onPressed:
                  _selectedWallet != null && _phoneController.text.isNotEmpty
                      ? () => _processPayment(totalAmount)
                      : () {}, // Provide a default no-op function
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}
