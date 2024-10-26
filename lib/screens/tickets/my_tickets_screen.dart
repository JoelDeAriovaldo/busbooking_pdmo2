import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../services/ticket_service.dart';
import '../../models/ticket.dart';
import '../../utils/constants.dart';

class MyTicketsScreen extends StatefulWidget {
  @override
  _MyTicketsScreenState createState() => _MyTicketsScreenState();
}

class _MyTicketsScreenState extends State<MyTicketsScreen> {
  final TicketService _ticketService = TicketService();
  final String userId = 'exampleUserId';

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.ticket,
            size: 64,
            color: Constants.textSecondaryColor,
          ),
          SizedBox(height: 16),
          Text(
            'Nenhuma passagem encontrada',
            style: Constants.subheadingStyle,
          ),
          SizedBox(height: 8),
          Text(
            'Suas passagens aparecerão aqui',
            style: Constants.bodyTextStyle.copyWith(
              color: Constants.textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketCard(Ticket ticket) {
    return Card(
      elevation: 0,
      color: Constants.surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.borderRadius),
        side: BorderSide(
          color: Constants.textSecondaryColor.withOpacity(0.1),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(Constants.borderRadius),
        onTap: () {
          Navigator.pushNamed(context, '/ticketDetails', arguments: ticket.id);
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Constants.primaryColor.withOpacity(0.1),
                    child: Icon(
                      LucideIcons.user,
                      color: Constants.primaryColor,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ticket.passengerName,
                          style: Constants.bodyTextStyle.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Passageiro',
                          style: Constants.bodyTextStyle.copyWith(
                            color: Constants.textSecondaryColor,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    LucideIcons.chevronRight,
                    color: Constants.textSecondaryColor,
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(
                    LucideIcons.calendar,
                    size: 16,
                    color: Constants.textSecondaryColor,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Data da viagem: ${ticket.travelDate}',
                    style: Constants.bodyTextStyle.copyWith(
                      color: Constants.textSecondaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Minhas Passagens',
                    style: Constants.headingStyle,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Gerencie suas viagens',
                    style: Constants.subheadingStyle,
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Ticket>>(
                future: _ticketService.getTicketsByUserId(userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Constants.primaryColor,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Erro ao carregar passagens',
                        style: Constants.bodyTextStyle,
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return _buildEmptyState();
                  } else {
                    return ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      itemCount: snapshot.data!.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 16),
                      itemBuilder: (context, index) =>
                          _buildTicketCard(snapshot.data![index]),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
