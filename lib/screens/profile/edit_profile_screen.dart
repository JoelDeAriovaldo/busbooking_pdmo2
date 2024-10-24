import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../services/auth_service.dart';
import '../../models/user.dart' as AppUser;
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _seatPreferenceController =
      TextEditingController();
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
        _nameController.text = userData?.name ?? '';
        _phoneController.text = userData?.phoneNumber ?? '';
        _seatPreferenceController.text = userData?.seatPreference ?? '';
      });
    }
  }

  Future<void> _updateUserData() async {
    if (_user != null) {
      await _authService.firestore.collection('users').doc(_user!.id).update({
        'name': _nameController.text,
        'phoneNumber': _phoneController.text,
        'seatPreference': _seatPreferenceController.text,
      });
      Helpers.showAlertDialog(
          context, 'Success', 'Profile updated successfully');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Padding(
        padding: Constants.defaultPadding,
        child: _user == null
            ? Center(child: CircularProgressIndicator())
            : Form(
                child: Column(
                  children: [
                    CustomTextField(
                      labelText: 'Name',
                      controller: _nameController,
                    ),
                    SizedBox(height: 16.0),
                    CustomTextField(
                      labelText: 'Phone Number',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 16.0),
                    CustomTextField(
                      labelText: 'Seat Preference',
                      controller: _seatPreferenceController,
                    ),
                    SizedBox(height: 16.0),
                    CustomButton(
                      text: 'Save',
                      onPressed: _updateUserData,
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
