import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
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
  bool _isLoading = false;
  String _passwordStrength = '';

  void _checkPasswordStrength(String password) {
    if (password.length < 6) {
      setState(() {
        _passwordStrength = 'Senha fraca';
      });
    } else if (password.length < 10) {
      setState(() {
        _passwordStrength = 'Senha média';
      });
    } else {
      setState(() {
        _passwordStrength = 'Senha forte';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Constants.surfaceColor,
        leading: IconButton(
          icon: Icon(LucideIcons.arrowLeft, color: Constants.textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Registrar',
          style: TextStyle(
              color: Constants.textColor, fontWeight: FontWeight.w600),
        ),
      ),
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
                  LucideIcons.userPlus,
                  size: 48,
                  color: Constants.primaryColor,
                ),
                SizedBox(height: 24),
                Text(
                  'Crie sua conta',
                  style: Constants.headingStyle,
                ),
                SizedBox(height: 8),
                Text(
                  'Preencha os campos abaixo para continuar',
                  style: Constants.subheadingStyle,
                ),
                SizedBox(height: 48),
                CustomTextField(
                  labelText: 'Nome',
                  controller: _nameController,
                  prefixIcon:
                      Icon(LucideIcons.user, color: Constants.primaryColor),
                ),
                SizedBox(height: 24),
                CustomTextField(
                  labelText: 'Número de Telefone',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon:
                      Icon(LucideIcons.phone, color: Constants.primaryColor),
                ),
                SizedBox(height: 24),
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
                  onChanged: _checkPasswordStrength,
                ),
                SizedBox(height: 8),
                Text(
                  _passwordStrength,
                  style: TextStyle(
                    color: _passwordStrength == 'Senha forte'
                        ? Colors.green
                        : _passwordStrength == 'Senha média'
                            ? Colors.orange
                            : Colors.red,
                  ),
                ),
                SizedBox(height: 32),
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : CustomButton(
                        text: 'Registrar',
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });
                            dynamic result =
                                await _authService.registerWithEmailAndPassword(
                              _emailController.text,
                              _passwordController.text,
                              _nameController.text,
                              _phoneController.text,
                            );
                            setState(() {
                              _isLoading = false;
                            });
                            if (result == null) {
                              Helpers.showAlertDialog(
                                context,
                                'Erro',
                                'Não foi possível registrar com essas credenciais',
                              );
                            } else {
                              // Navigate to home screen or another screen
                            }
                          }
                        },
                      ),
                SizedBox(height: 16),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text(
                      'Já tem uma conta? Faça login',
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
