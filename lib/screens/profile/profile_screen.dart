import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../services/auth_service.dart';
import '../../models/user.dart' as AppUser;
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/custom_button.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  AppUser.User? _user;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    firebase_auth.User? currentUser = _authService.auth.currentUser;
    if (currentUser != null) {
      AppUser.User? userData = await _authService.getUserData(currentUser.uid);
      setState(() {
        _user = userData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(context, '/editProfile');
            },
          ),
        ],
      ),
      body: Padding(
        padding: Constants.defaultPadding,
        child: _user == null
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${_user!.name}', style: Constants.bodyTextStyle),
                  SizedBox(height: 8.0),
                  Text('Phone: ${_user!.phoneNumber}',
                      style: Constants.bodyTextStyle),
                  SizedBox(height: 8.0),
                  Text('Email: ${_user!.email}',
                      style: Constants.bodyTextStyle),
                  SizedBox(height: 8.0),
                  Text('Seat Preference: ${_user!.seatPreference}',
                      style: Constants.bodyTextStyle),
                  SizedBox(height: 8.0),
                  Text('Travel History:', style: Constants.bodyTextStyle),
                  ..._user!.travelHistory
                      .map((history) =>
                          Text(history, style: Constants.bodyTextStyle))
                      .toList(),
                  SizedBox(height: 16.0),
                  CustomButton(
                    text: 'Logout',
                    onPressed: () async {
                      await _authService.signOut();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
