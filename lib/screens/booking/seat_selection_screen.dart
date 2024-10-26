import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
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
    final arguments = ModalRoute.of(context)?.settings.arguments;
    final AppRoute.Route? route =
        arguments is AppRoute.Route ? arguments : null;

    if (route == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(LucideIcons.arrowLeft),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('Erro'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(LucideIcons.alertCircle, size: 48, color: Colors.red),
              SizedBox(height: 16),
              Text('Informação da rota inválida'),
            ],
          ),
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
          'Selecionar Lugares',
          style: TextStyle(
              color: Constants.textColor, fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: Constants.defaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRouteCard(route),
              SizedBox(height: 24.0),
              _buildLegend(),
              SizedBox(height: 24.0),
              SeatLayout(
                rows: 5,
                columns: 4,
                bookedSeats: _bookedSeats,
                selectedSeats: _selectedSeats,
                onSeatSelected: _onSeatSelected,
              ),
              SizedBox(height: 24.0),
              if (_selectedSeats.isNotEmpty) _buildSelectedSeatsCard(),
              SizedBox(height: 24.0),
              _buildContinueButton(route),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRouteCard(AppRoute.Route route) {
    return Card(
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
                  Icon(LucideIcons.clock, size: 20, color: Constants.textColor),
                  SizedBox(width: 12),
                  Text(
                    'Duração estimada: 2h 30m',
                    style: TextStyle(color: Constants.textColor),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildLegendItem(
            'Disponível', Constants.surfaceColor, Constants.textSecondaryColor),
        _buildLegendItem(
            'Selecionado', Constants.primaryColor, Constants.primaryColor),
        _buildLegendItem('Reservado', Constants.textSecondaryColor,
            Constants.textSecondaryColor),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color fillColor, Color borderColor) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: fillColor,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        SizedBox(width: 8),
        Text(label, style: TextStyle(color: Constants.textSecondaryColor)),
      ],
    );
  }

  Widget _buildSelectedSeatsCard() {
    return Card(
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
          child: Row(
            children: [
              Icon(LucideIcons.armchair, color: Constants.textColor),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Lugares Selecionados: ${_selectedSeats.join(", ")}',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Constants.textColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton(AppRoute.Route route) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _selectedSeats.isEmpty
            ? null
            : () {
                final List<int> selectedSeatsList = _selectedSeats.toList();
                Navigator.pushNamed(
                  context,
                  selectedSeatsList.length > 1
                      ? '/passengerDetails'
                      : '/bookingConfirmation',
                  arguments: {
                    'route': route,
                    'seats': selectedSeatsList,
                    if (selectedSeatsList.length == 1)
                      'seat': selectedSeatsList[0],
                  },
                );
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: Constants.primaryColor,
          foregroundColor: Constants.textColor,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Constants.borderRadius),
          ),
          elevation: 0,
        ),
        child: Text(
          'Continuar',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
