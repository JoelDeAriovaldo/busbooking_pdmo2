import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../models/ticket.dart';
import '../../services/ticket_service.dart';
import '../../utils/constants.dart';
import 'package:intl/intl.dart';

class TicketDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String ticketId =
        ModalRoute.of(context)!.settings.arguments as String;

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
          'Detalhes da Passagem',
          style: TextStyle(
              color: Constants.textColor, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: Icon(LucideIcons.share2, color: Constants.textColor),
            onPressed: () {
              // Implementar funcionalidade de partilha
            },
          ),
        ],
      ),
      body: FutureBuilder<Ticket?>(
        future: TicketService().getTicketById(ticketId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(Constants.primaryColor),
              ),
            );
          } else if (snapshot.hasError) {
            return _buildErrorState(snapshot.error.toString());
          } else if (!snapshot.hasData || snapshot.data == null) {
            return _buildEmptyState();
          } else {
            return _buildTicketDetails(context, snapshot.data!);
          }
        },
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.alertCircle, size: 48, color: Colors.red[400]),
          SizedBox(height: 16),
          Text(
            'Algo correu mal',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Constants.textColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            error,
            style: TextStyle(color: Constants.textSecondaryColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.ticket,
              size: 48, color: Constants.textSecondaryColor),
          SizedBox(height: 16),
          Text(
            'Passagem não encontrada',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Constants.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketDetails(BuildContext context, Ticket ticket) {
    return SingleChildScrollView(
      child: Padding(
        padding: Constants.defaultPadding,
        child: Column(
          children: [
            _buildTicketCard(ticket),
            SizedBox(height: 24),
            _buildPassengerCard(ticket),
            SizedBox(height: 24),
            _buildTravelCard(ticket),
            SizedBox(height: 24),
            _buildQRCode(ticket),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketCard(Ticket ticket) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.borderRadius),
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
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ID da Reserva',
                        style: TextStyle(
                          color: Constants.textSecondaryColor,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        ticket.id.substring(0, 8).toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Constants.textColor,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Confirmado',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              Divider(height: 32, color: Constants.textSecondaryColor),
              _buildInfoRow(
                LucideIcons.armchair,
                'Assento',
                ticket.seatNumber.toString(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPassengerCard(Ticket ticket) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.borderRadius),
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
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Detalhes do Passageiro',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Constants.textColor,
                ),
              ),
              SizedBox(height: 16),
              _buildInfoRow(
                LucideIcons.user,
                'Nome',
                ticket.passengerName,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTravelCard(Ticket ticket) {
    final DateFormat dateFormat = DateFormat('dd MMM, yyyy');
    final DateFormat timeFormat = DateFormat('HH:mm');

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.borderRadius),
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
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Informações da Viagem',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Constants.textColor,
                ),
              ),
              SizedBox(height: 16),
              _buildInfoRow(
                LucideIcons.calendar,
                'Data da Viagem',
                dateFormat.format(ticket.travelDate),
              ),
              SizedBox(height: 12),
              _buildInfoRow(
                LucideIcons.bus,
                'ID do Veículo',
                ticket.vehicleId,
              ),
              SizedBox(height: 12),
              _buildInfoRow(
                LucideIcons.router,
                'ID da Rota',
                ticket.routeId,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQRCode(Ticket ticket) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.borderRadius),
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
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Constants.surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  LucideIcons.qrCode,
                  size: 100,
                  color: Constants.textSecondaryColor,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Mostre este QR code ao condutor do autocarro',
                style: TextStyle(
                  color: Constants.textSecondaryColor,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Constants.textSecondaryColor),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Constants.textSecondaryColor,
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Constants.textColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
