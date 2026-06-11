import 'package:flutter/material.dart';
import 'usersession.dart';
import 'package:fleettracker_admin_app/fieldAgent/registercarpage.dart';
import 'package:fleettracker_admin_app/admin/carslist.dart';

class CustomDrawer extends StatelessWidget {
  final UserSession session;
  final VoidCallback onLogout;

  const CustomDrawer({
    super.key, 
    required this.session,
    required this.onLogout
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
        backgroundColor: Color.fromARGB(255, 20, 30, 39),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: Text(
                "Menu",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.directions_car, color: Colors.white),
              title: Text(
                "Cadastrar Veículo",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RegisterCarPage(session: session, onLogout: onLogout),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.map, color: Colors.white),
              title: Text(
                "Veículos Cadastrados",
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CarsList(session: session, onLogout: onLogout),
                  ),
                );
              },
            ),
          ],
        ),
      );
  }
}