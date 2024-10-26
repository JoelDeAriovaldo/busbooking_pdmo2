import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../models/route.dart' as AppRoute;
import '../../services/route_service.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_button.dart';

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
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Widget _buildLocationDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Constants.surfaceColor,
        borderRadius: BorderRadius.circular(Constants.borderRadius),
        border: Border.all(
          color: Constants.textSecondaryColor.withOpacity(0.1),
        ),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        hint: Text(
          hint,
          style: Constants.bodyTextStyle.copyWith(
            color: Constants.textSecondaryColor,
          ),
        ),
        items: items.map((String location) {
          return DropdownMenuItem<String>(
            value: location,
            child: Text(
              location,
              style: Constants.bodyTextStyle,
            ),
          );
        }).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Constants.borderRadius),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          filled: true,
          fillColor: Colors.transparent,
        ),
        dropdownColor: Constants.surfaceColor,
      ),
    );
  }

  Widget _buildRouteCard(AppRoute.Route route) {
    return Card(
      color: Constants.surfaceColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.borderRadius),
        side: BorderSide(
          color: Constants.textSecondaryColor.withOpacity(0.1),
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(Constants.borderRadius),
        onTap: () {
          Navigator.pushNamed(context, '/seatSelection', arguments: route);
        },
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    LucideIcons.bus,
                    color: Constants.primaryColor,
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          route.startLocation,
                          style: Constants.bodyTextStyle.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          route.endLocation,
                          style: Constants.bodyTextStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        LucideIcons.clock,
                        color: Constants.textSecondaryColor,
                        size: 16,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${route.duration.inHours}h ${route.duration.inMinutes % 60}m',
                        style: Constants.bodyTextStyle.copyWith(
                          color: Constants.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                  if (_schedules.isNotEmpty)
                    Text(
                      _schedules.join(', '),
                      style: Constants.bodyTextStyle.copyWith(
                        color: Constants.primaryColor,
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
    return SingleChildScrollView(
      padding: Constants.defaultPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Para onde você vai?',
            style: Constants.headingStyle,
          ),
          SizedBox(height: 8),
          Text(
            'Encontre as melhores rotas para sua viagem',
            style: Constants.subheadingStyle,
          ),
          SizedBox(height: 32),
          _buildLocationDropdown(
            hint: 'Local de partida',
            value: _selectedStartLocation,
            items: _startLocations,
            onChanged: (newValue) {
              setState(() {
                _selectedStartLocation = newValue;
                _selectedEndLocation = null;
                _endLocations = [];
              });
              _fetchEndLocations(newValue!);
            },
          ),
          SizedBox(height: 16),
          _buildLocationDropdown(
            hint: 'Local de chegada',
            value: _selectedEndLocation,
            items: _endLocations,
            onChanged: (newValue) {
              setState(() {
                _selectedEndLocation = newValue;
              });
            },
          ),
          SizedBox(height: 16),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: Container(
              decoration: BoxDecoration(
                color: Constants.surfaceColor,
                borderRadius: BorderRadius.circular(Constants.borderRadius),
                border: Border.all(
                  color: Constants.textSecondaryColor.withOpacity(0.1),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  Icon(
                    LucideIcons.calendar,
                    color: Constants.textSecondaryColor,
                  ),
                  SizedBox(width: 12),
                  Text(
                    _dateController.text.isEmpty
                        ? 'Selecione a data'
                        : _dateController.text,
                    style: Constants.bodyTextStyle.copyWith(
                      color: _dateController.text.isEmpty
                          ? Constants.textSecondaryColor
                          : Constants.textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 32),
          CustomButton(
            text: 'Buscar rotas',
            onPressed: _searchRoutes,
          ),
          if (_distance != null && _time != null) ...[
            SizedBox(height: 24),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Constants.surfaceColor,
                borderRadius: BorderRadius.circular(Constants.borderRadius),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Icon(
                        LucideIcons.mapPin,
                        color: Constants.primaryColor,
                      ),
                      SizedBox(height: 8),
                      Text(
                        '$_distance km',
                        style: Constants.bodyTextStyle,
                      ),
                      Text(
                        'Distância',
                        style: Constants.subheadingStyle,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(
                        LucideIcons.clock,
                        color: Constants.primaryColor,
                      ),
                      SizedBox(height: 8),
                      Text(
                        '$_time min',
                        style: Constants.bodyTextStyle,
                      ),
                      Text(
                        'Duração',
                        style: Constants.subheadingStyle,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: 24),
          if (_routes.isNotEmpty) ...[
            Text(
              'Rotas disponíveis',
              style: Constants.subheadingStyle,
            ),
            SizedBox(height: 16),
            ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _routes.length,
              separatorBuilder: (context, index) => SizedBox(height: 16),
              itemBuilder: (context, index) => _buildRouteCard(_routes[index]),
            ),
          ],
        ],
      ),
    );
  }
}
