import 'package:fleettracker_admin_app/admin/carslist.dart';
import 'package:fleettracker_admin_app/dashboard.dart';
import 'package:fleettracker_admin_app/usersession.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final UserSession session;
  final VoidCallback onLogout;

  const HomePage({super.key, required this.session, required this.onLogout});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DashBoard(session: widget.session, onLogout: widget.onLogout),
    );
  }
}
