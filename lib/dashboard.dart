import 'package:fleettracker_admin_app/admin/carslist.dart';
import 'package:fleettracker_admin_app/fieldAgent/registercarpage.dart';
import 'package:fleettracker_admin_app/usersession.dart';
import 'package:flutter/material.dart';

class DashBoard extends StatelessWidget {
  final UserSession session;
  final VoidCallback onLogout;

  const DashBoard({super.key, required this.session, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Fleet",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextSpan(
                text: "Tracker",
                style: TextStyle(fontSize: 29, color: Colors.grey),
              ),
            ],
          ),
        ),
        // Text("FleetTracker", style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 49, 56, 64),
        actions: [
          IconButton(
            onPressed: onLogout,
            icon: Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 20, 30, 39),
      drawer: Drawer(
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
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 170,
              child: AspectRatio(
                aspectRatio: 1.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterCarPage(
                          session: session,
                          onLogout: onLogout,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.directions_car, size: 40, color: Colors.white),
                      SizedBox(height: 10),
                      Text(
                        "Cadastrar Veículo",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10, width: 10),
            SizedBox(
              width: 170,
              child: AspectRatio(
                aspectRatio: 1.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    backgroundColor: Colors.greenAccent,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CarsList(session: session, onLogout: onLogout),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map, size: 40, color: Colors.white),
                      SizedBox(height: 10),
                      Text(
                        "Veículos Cadastrados",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
