import 'package:flutter/material.dart';
import '../../services/payment_service.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final PaymentService _paymentService = PaymentService();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _paymentMethodController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _processPayment() async {
    if (_formKey.currentState!.validate()) {
      String userId = 'exampleUserId'; // Replace with actual user ID
      double amount = double.parse(_amountController.text);
      String paymentMethod = _paymentMethodController.text;

      await _paymentService.processPayment(userId, amount, paymentMethod);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment processed successfully')),
      );

      // Navigate to another screen or perform other actions
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Padding(
        padding: Constants.defaultPadding,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                labelText: 'Amount',
                controller: _amountController,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.0),
              CustomTextField(
                labelText: 'Payment Method',
                controller: _paymentMethodController,
              ),
              SizedBox(height: 16.0),
              CustomButton(
                text: 'Process Payment',
                onPressed: _processPayment,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
