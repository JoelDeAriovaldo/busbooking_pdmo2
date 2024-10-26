import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
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
          SnackBar(content: Text('Pagamento processado com sucesso')),
        );

        // Navigate to MyTicketsScreen
        Navigator.pushReplacementNamed(context, '/myTickets');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Falha no pagamento: ${e.toString()}')),
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
          title: Text('Erro'),
        ),
        body: Center(
          child: Text('Informação de pagamento inválida'),
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
          title: Text('Erro'),
        ),
        body: Center(
          child: Text('Nenhuma informação de assento fornecida'),
        ),
      );
    }

    if (route == null || seats == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Erro'),
        ),
        body: Center(
          child: Text('Informação de rota ou assento ausente'),
        ),
      );
    }

    final double totalAmount = route.price * seats.length;

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
          'Pagamento',
          style: TextStyle(
              color: Constants.textColor, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
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
                            'Assentos Selecionados: ${seats.join(", ")}',
                            style: TextStyle(color: Constants.textColor),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(LucideIcons.dollarSign,
                              size: 20, color: Constants.textColor),
                          SizedBox(width: 12),
                          Text(
                            'Valor Total: \$${totalAmount.toStringAsFixed(2)}',
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
            Text(
              'Selecione o Método de Pagamento:',
              style: Constants.subheadingStyle,
            ),
            SizedBox(height: 16.0),
            ..._wallets.map((wallet) => RadioListTile<String>(
                  title: Text(wallet, style: Constants.bodyTextStyle),
                  value: wallet,
                  groupValue: _selectedWallet,
                  onChanged: (value) {
                    setState(() {
                      _selectedWallet = value;
                    });
                  },
                  activeColor: Constants.primaryColor,
                )),
            if (_selectedWallet != null) ...[
              SizedBox(height: 16.0),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: Constants.bodyTextStyle,
                decoration: InputDecoration(
                  labelText: 'Número de Telefone',
                  hintText: 'Insira o seu número de telefone',
                  labelStyle: Constants.subheadingStyle,
                  hintStyle: Constants.bodyTextStyle.copyWith(
                    color: Constants.textSecondaryColor,
                  ),
                  filled: true,
                  fillColor: Constants.surfaceColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Constants.borderRadius),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Constants.borderRadius),
                    borderSide: BorderSide(
                        color: Constants.textSecondaryColor.withOpacity(0.1)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(Constants.borderRadius),
                    borderSide: BorderSide(color: Constants.primaryColor),
                  ),
                ),
              ),
            ],
            SizedBox(height: 24.0),
            CustomButton(
              text: 'Pagar Agora',
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
