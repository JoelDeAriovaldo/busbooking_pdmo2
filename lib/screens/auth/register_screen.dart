import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: Constants.defaultPadding,
        child: Form(
          key: _formKey,
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
                labelText: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16.0),
              CustomTextField(
                labelText: 'Password',
                controller: _passwordController,
                obscureText: true,
              ),
              SizedBox(height: 16.0),
              CustomButton(
                text: 'Register',
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    dynamic result =
                        await _authService.registerWithEmailAndPassword(
                      _emailController.text,
                      _passwordController.text,
                      _nameController.text,
                      _phoneController.text,
                    );
                    if (result == null) {
                      Helpers.showAlertDialog(context, 'Error',
                          'Could not register with those credentials');
                    } else {
                      // Navigate to home screen or another screen
                    }
                  }
                },
              ),
              TextButton(
                onPressed: () {
                  // Navigate to login screen
                  Navigator.pushNamed(context, '/login');
                },
                child: Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
