import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:lucide_icons/lucide_icons.dart';
import '../../services/auth_service.dart';
import '../../models/user.dart' as AppUser;
import '../../utils/constants.dart';
import '../../utils/helpers.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  AppUser.User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      firebase_auth.User? currentUser = _authService.auth.currentUser;
      if (currentUser != null) {
        AppUser.User? userData =
            await _authService.getUserData(currentUser.uid);
        setState(() {
          _user = userData;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao carregar dados do perfil')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Constants.surfaceColor,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(LucideIcons.userX,
              size: 48, color: Constants.textSecondaryColor),
          SizedBox(height: 16),
          Text(
            'Perfil não encontrado',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Constants.textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfile() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProfileHeader(),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildPersonalInfoCard(),
                SizedBox(height: 16),
                _buildPreferencesCard(),
                SizedBox(height: 16),
                _buildTravelHistoryCard(),
                SizedBox(height: 24),
                _buildActionButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Constants.primaryColor.withOpacity(0.2),
                child: Text(
                  _user!.name[0].toUpperCase(),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Constants.primaryColor,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Constants.surfaceColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(LucideIcons.edit3,
                        size: 20, color: Constants.textColor),
                    onPressed: () {
                      Navigator.pushNamed(context, '/editProfile');
                    },
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Text(
            _user!.name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Constants.textColor,
            ),
          ),
          SizedBox(height: 4),
          Text(
            _user!.email,
            style: TextStyle(
              color: Constants.textSecondaryColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.borderRadius),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Constants.borderRadius),
          gradient: LinearGradient(
            colors: [Constants.primaryColor, Constants.secondaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Informações Pessoais',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Constants.textColor,
                ),
              ),
              SizedBox(height: 16),
              _buildInfoRow(LucideIcons.phone, 'Telefone', _user!.phoneNumber),
              SizedBox(height: 12),
              _buildInfoRow(LucideIcons.mail, 'E-mail', _user!.email),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreferencesCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.borderRadius),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Constants.borderRadius),
          gradient: LinearGradient(
            colors: [Constants.primaryColor, Constants.secondaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Preferências',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Constants.textColor,
                ),
              ),
              SizedBox(height: 16),
              _buildInfoRow(
                LucideIcons.armchair,
                'Preferência de Assento',
                _user!.seatPreference,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTravelHistoryCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.borderRadius),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Constants.borderRadius),
          gradient: LinearGradient(
            colors: [Constants.primaryColor, Constants.secondaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Histórico de Viagens',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Constants.textColor,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to detailed history
                    },
                    child: Text('Ver Tudo',
                        style: TextStyle(color: Constants.textColor)),
                  ),
                ],
              ),
              SizedBox(height: 16),
              if (_user!.travelHistory.isEmpty)
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(LucideIcons.mapPin,
                            size: 48, color: Constants.textSecondaryColor),
                        SizedBox(height: 8),
                        Text(
                          'Ainda não há histórico de viagens',
                          style: TextStyle(color: Constants.textSecondaryColor),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _user!.travelHistory.length.clamp(0, 3),
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading:
                          Icon(LucideIcons.bus, color: Constants.textColor),
                      title: Text(_user!.travelHistory[index],
                          style: TextStyle(color: Constants.textColor)),
                      contentPadding: EdgeInsets.zero,
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/editProfile');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Constants.primaryColor,
            foregroundColor: Constants.textColor,
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Constants.borderRadius),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.edit3),
              SizedBox(width: 8),
              Text('Editar Perfil'),
            ],
          ),
        ),
        SizedBox(height: 12),
        TextButton(
          onPressed: () async {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Terminar Sessão'),
                content: Text('Tem a certeza que deseja terminar sessão?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () async {
                      await _authService.signOut();
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text('Terminar Sessão',
                        style: TextStyle(color: Colors.red[700])),
                  ),
                ],
              ),
            );
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.logOut, color: Colors.red[700]),
              SizedBox(width: 8),
              Text('Terminar Sessão', style: TextStyle(color: Colors.red[700])),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Constants.textSecondaryColor),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Constants.textSecondaryColor,
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: Constants.textColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
