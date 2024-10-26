import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
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
          title: Text('Erro'),
        ),
        body: Center(
          child: Text('Informação de passageiro inválida'),
        ),
      );
    }

    final route = args['route'] as AppRoute.Route?;
    final seats = args['seats'] as List<int>?;

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

    if (_passengersControllers.isEmpty) {
      for (int i = 0; i < seats.length; i++) {
        _passengersControllers.add({
          'name': TextEditingController(),
          'phone': TextEditingController(),
        });
      }
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
          'Detalhes do Passageiro',
          style: TextStyle(
              color: Constants.textColor, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: Constants.defaultPadding,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rota: ${route.startLocation} para ${route.endLocation}',
                style: Constants.headingStyle,
              ),
              SizedBox(height: 16.0),
              Text(
                'Assentos Selecionados: ${seats.join(", ")}',
                style: Constants.subheadingStyle,
              ),
              SizedBox(height: 24.0),
              ..._buildPassengerForms(seats),
              SizedBox(height: 24.0),
              CustomButton(
                text: 'Continuar para Pagamento',
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
    for (int i = 0; i < seats.length; i++) {
      forms.addAll([
        Text(
          'Passageiro ${i + 1} (Assento ${seats[i]})',
          style: Constants.subheadingStyle.copyWith(
            fontWeight: FontWeight.bold,
            color: Constants.textColor,
          ),
        ),
        SizedBox(height: 8.0),
        CustomTextField(
          labelText: 'Nome Completo',
          controller: _passengersControllers[i]['name']!,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira o nome do passageiro';
            }
            return null;
          },
        ),
        SizedBox(height: 8.0),
        CustomTextField(
          labelText: 'Número de Telefone',
          controller: _passengersControllers[i]['phone']!,
          keyboardType: TextInputType.phone,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira o número de telefone';
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
