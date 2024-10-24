import 'package:flutter/material.dart';
import '../../models/route.dart' as AppRoute;
import '../../services/route_service.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _startLocationController =
      TextEditingController();
  final TextEditingController _endLocationController = TextEditingController();
  List<AppRoute.Route> _routes = [];

  void _searchRoutes() async {
    String startLocation = _startLocationController.text;
    String endLocation = _endLocationController.text;

    List<AppRoute.Route> routes =
        await RouteService().searchRoutes(startLocation, endLocation);
    setState(() {
      _routes = routes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Routes'),
      ),
      body: Padding(
        padding: Constants.defaultPadding,
        child: Column(
          children: [
            CustomTextField(
              labelText: 'Start Location',
              controller: _startLocationController,
            ),
            SizedBox(height: 16.0),
            CustomTextField(
              labelText: 'End Location',
              controller: _endLocationController,
            ),
            SizedBox(height: 16.0),
            CustomButton(
              text: 'Search',
              onPressed: _searchRoutes,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _routes.length,
                itemBuilder: (context, index) {
                  AppRoute.Route route = _routes[index];
                  return ListTile(
                    title:
                        Text('${route.startLocation} to ${route.endLocation}'),
                    subtitle: Text(
                        'Duration: ${route.duration.inHours}h ${route.duration.inMinutes % 60}m'),
                    onTap: () {
                      Navigator.pushNamed(context, '/seatSelection',
                          arguments: route);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
