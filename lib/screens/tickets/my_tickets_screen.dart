import 'package:flutter/material.dart';
import '../../services/ticket_service.dart';
import '../../models/ticket.dart';
import '../../utils/constants.dart';

class MyTicketsScreen extends StatefulWidget {
  @override
  _MyTicketsScreenState createState() => _MyTicketsScreenState();
}

class _MyTicketsScreenState extends State<MyTicketsScreen> {
  final TicketService _ticketService = TicketService();
  final String userId = 'exampleUserId'; // Replace with actual user ID

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Tickets'),
      ),
      body: FutureBuilder<List<Ticket>>(
        future: _ticketService.getTicketsByUserId(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No tickets found'));
          } else {
            List<Ticket> tickets = snapshot.data!;
            return ListView.builder(
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                Ticket ticket = tickets[index];
                return ListTile(
                  title: Text('Ticket for ${ticket.passengerName}'),
                  subtitle: Text('Travel Date: ${ticket.travelDate}'),
                  onTap: () {
                    Navigator.pushNamed(context, '/ticketDetails',
                        arguments: ticket.id);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
