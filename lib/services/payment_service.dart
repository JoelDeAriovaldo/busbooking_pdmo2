import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentService {
  final CollectionReference paymentCollection =
      FirebaseFirestore.instance.collection('payments');

  // Process payment
  Future<void> processPayment(
      String userId, double amount, String paymentMethod) async {
    try {
      await paymentCollection.add({
        'userId': userId,
        'amount': amount,
        'paymentMethod': paymentMethod,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print(e.toString());
    }
  }

  // Get payment history for a user
  Future<List<Map<String, dynamic>>> getPaymentHistory(String userId) async {
    try {
      QuerySnapshot querySnapshot =
          await paymentCollection.where('userId', isEqualTo: userId).get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
