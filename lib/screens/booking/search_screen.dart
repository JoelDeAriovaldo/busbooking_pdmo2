import 'package:flutter/material.dart';
import '../../models/route.dart' as AppRoute;
import '../../services/route_service.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _dateController = TextEditingController();
  String? _selectedStartLocation;
  String? _selectedEndLocation;
  List<AppRoute.Route> _routes = [];
  List<String> _schedules = [];
  List<String> _startLocations = [];
  List<String> _endLocations = [];
  int? _distance;
  int? _time;

  @override
  void initState() {
    super.initState();
    _fetchStartLocations();
  }

  void _fetchStartLocations() async {
    List<String> startLocations = await RouteService().getStartLocations();
    setState(() {
      _startLocations = startLocations;
    });
  }

  void _fetchEndLocations(String startLocation) async {
    List<String> endLocations =
        await RouteService().getEndLocations(startLocation);
    setState(() {
      _endLocations = endLocations;
    });
  }

  void _searchRoutes() async {
    if (_selectedStartLocation == null ||
        _selectedEndLocation == null ||
        _dateController.text.isEmpty) {
      Helpers.showAlertDialog(context, 'Error', 'Please fill all fields');
      return;
    }

    String startLocation = _selectedStartLocation!;
    String endLocation = _selectedEndLocation!;
    String date = _dateController.text;

    List<AppRoute.Route> routes =
        await RouteService().searchRoutes(startLocation, endLocation);
    setState(() {
      _routes = routes;
    });

    if (_routes.isNotEmpty) {
      String routeId = _routes.first.id;
      List<String> schedules =
          await RouteService().getAvailableSchedules(routeId, date);
      setState(() {
        _schedules = schedules;
      });

      Map<String, dynamic>? distanceAndTime =
          await RouteService().getDistanceAndTime(startLocation, endLocation);
      if (distanceAndTime != null) {
        setState(() {
          _distance = distanceAndTime['distance'];
          _time = distanceAndTime['time'];
        });
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = Helpers.formatDate(picked);
      });
    }
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
            DropdownButtonFormField<String>(
              value: _selectedStartLocation,
              hint: Text('Select Start Location'),
              items: _startLocations.map((String location) {
                return DropdownMenuItem<String>(
                  value: location,
                  child: Text(location),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedStartLocation = newValue;
                  _selectedEndLocation = null;
                  _endLocations = [];
                });
                _fetchEndLocations(newValue!);
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              ),
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: _selectedEndLocation,
              hint: Text('Select End Location'),
              items: _endLocations.map((String location) {
                return DropdownMenuItem<String>(
                  value: location,
                  child: Text(location),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedEndLocation = newValue;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _dateController,
              readOnly: true,
              onTap: () => _selectDate(context),
              decoration: InputDecoration(
                labelText: 'Date',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              ),
            ),
            SizedBox(height: 16.0),
            CustomButton(
              text: 'Search',
              onPressed: _searchRoutes,
            ),
            if (_distance != null && _time != null) ...[
              SizedBox(height: 16.0),
              Text('Distance: $_distance km'),
              Text('Time: $_time minutes'),
            ],
            Expanded(
              child: ListView.builder(
                itemCount: _routes.length,
                itemBuilder: (context, index) {
                  AppRoute.Route route = _routes[index];
                  return ListTile(
                    title:
                        Text('${route.startLocation} to ${route.endLocation}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Duration: ${route.duration.inHours}h ${route.duration.inMinutes % 60}m'),
                        if (_schedules.isNotEmpty)
                          Text('Available Times: ${_schedules.join(', ')}'),
                      ],
                    ),
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
