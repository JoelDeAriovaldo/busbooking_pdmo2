import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/profile/edit_profile_screen.dart';
import 'screens/booking/search_screen.dart';
import 'screens/booking/seat_selection_screen.dart';
import 'screens/booking/booking_confirmation_screen.dart';
import 'screens/tickets/my_tickets_screen.dart';
import 'screens/tickets/ticket_details_screen.dart';
import 'screens/travel_info/route_details_screen.dart';
import 'screens/travel_info/vehicle_info_screen.dart';
import 'screens/payment/payment_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bus Booking App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/profile': (context) => ProfileScreen(),
        '/editProfile': (context) => EditProfileScreen(),
        '/search': (context) => SearchScreen(),
        '/seatSelection': (context) => SeatSelectionScreen(),
        '/bookingConfirmation': (context) => BookingConfirmationScreen(),
        '/myTickets': (context) => MyTicketsScreen(),
        '/ticketDetails': (context) => TicketDetailsScreen(),
        '/routeDetails': (context) => RouteDetailsScreen(),
        '/vehicleInfo': (context) => VehicleInfoScreen(),
        '/payment': (context) => PaymentScreen(),
      },
    );
  }
}
