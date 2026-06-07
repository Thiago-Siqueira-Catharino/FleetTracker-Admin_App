import 'package:fleettracker_admin_app/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fleettracker_admin_app/usersession.dart';
import 'package:flutter/material.dart';
import 'homepage.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() {
    return _MainAppState();
  }
}

class _MainAppState extends State<MainApp> {
  UserSession? _session;
  bool _checkingSession = true;

  @override
  void initState() {
    super.initState();
    _loadSession(); // Verifica se já tem login salvo ao abrir o app
  }

  Future<void> _loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('jwt_token');
    final String? email = prefs.getString('user_email');

    if (token != null && email != null) {
      setState(() {
        _session = UserSession(email: email, token: token);
      });
    }
    setState(() => _checkingSession = false);
  }

  Future<void> _onLoginSuccess(UserSession session) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', session.token);
    await prefs.setString('user_email', session.email);

    setState(() {
      _session = session;
    });
  }

  Future<void> _onLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    await prefs.remove('user_email');

    setState(() {
      _session = null;
    });
  }

  @override
  Widget build(BuildContext content) {
    if (_checkingSession) {
      return const MaterialApp(
        home: Scaffold(
          body: Center(child: CircularProgressIndicator())
        )
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _session != null ? HomePage(session: _session!, onLogout: _onLogout) : LoginPage(onLoginSuccess: _onLoginSuccess),
    );
  }
}