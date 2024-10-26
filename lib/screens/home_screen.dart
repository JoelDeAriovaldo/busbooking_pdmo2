import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'booking/search_screen.dart';
import 'tickets/my_tickets_screen.dart';
import 'profile/profile_screen.dart';
import '../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        backgroundColor: Constants.surfaceColor,
        elevation: 0,
        title: Text(
          'BusBooking',
          style: Constants.headingStyle.copyWith(
            fontSize: 24,
            color: Constants.primaryColor,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Constants.primaryColor,
          indicatorWeight: 3,
          labelColor: Constants.primaryColor,
          unselectedLabelColor: Constants.textSecondaryColor,
          tabs: [
            Tab(
              icon: Icon(LucideIcons.search),
              text: 'Buscar',
            ),
            Tab(
              icon: Icon(LucideIcons.ticket),
              text: 'Passagens',
            ),
            Tab(
              icon: Icon(LucideIcons.user),
              text: 'Perfil',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          SearchScreen(),
          MyTicketsScreen(),
          ProfileScreen(),
        ],
      ),
    );
  }
}
