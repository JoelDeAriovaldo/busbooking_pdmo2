import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ticket.dart';

class TicketService {
  final CollectionReference ticketCollection =
      FirebaseFirestore.instance.collection('tickets');

  // Create a new ticket
  Future<void> createTicket(Ticket ticket) async {
    try {
      await ticketCollection.doc(ticket.id).set(ticket.toJson());
    } catch (e) {
      print(e.toString());
    }
  }

  // Get ticket by ID
  Future<Ticket?> getTicketById(String id) async {
    try {
      DocumentSnapshot doc = await ticketCollection.doc(id).get();
      return Ticket.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Get all tickets for a user
  Future<List<Ticket>> getTicketsByUserId(String userId) async {
    try {
      QuerySnapshot querySnapshot =
          await ticketCollection.where('userId', isEqualTo: userId).get();
      return querySnapshot.docs
          .map((doc) => Ticket.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
