import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: Constants.defaultPadding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40),
                Icon(
                  LucideIcons.logIn,
                  size: 48,
                  color: Constants.primaryColor,
                ),
                SizedBox(height: 24),
                Text(
                  'Bem-vindo de volta',
                  style: Constants.headingStyle,
                ),
                SizedBox(height: 8),
                Text(
                  'Faça login para continuar',
                  style: Constants.subheadingStyle,
                ),
                SizedBox(height: 48),
                CustomTextField(
                  labelText: 'E-mail',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon:
                      Icon(LucideIcons.mail, color: Constants.primaryColor),
                ),
                SizedBox(height: 24),
                CustomTextField(
                  labelText: 'Senha',
                  controller: _passwordController,
                  obscureText: true,
                  prefixIcon:
                      Icon(LucideIcons.lock, color: Constants.primaryColor),
                ),
                SizedBox(height: 32),
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : CustomButton(
                        text: 'Entrar',
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });
                            dynamic result =
                                await _authService.signInWithEmailAndPassword(
                              _emailController.text,
                              _passwordController.text,
                            );
                            setState(() {
                              _isLoading = false;
                            });
                            if (result == null) {
                              Helpers.showAlertDialog(
                                context,
                                'Erro',
                                'Email não cadastrado ou senha incorreta',
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()),
                              );
                            }
                          }
                        },
                      ),
                SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text(
                      'Não tem uma conta? Cadastre-se',
                      style: Constants.bodyTextStyle.copyWith(
                        color: Constants.primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
