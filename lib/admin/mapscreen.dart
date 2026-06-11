import 'dart:convert';
import 'package:fleettracker_admin_app/usersession.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'classes.dart' as model;

class MapScreen extends StatefulWidget {
  final VoidCallback onLogout;
  final UserSession session;
  final model.Path path;

  const MapScreen({
    super.key,
    required this.onLogout,
    required this.session,
    required this.path
  });

  @override
  State<StatefulWidget> createState() {
    return _MapScreenState();
  }
}

class _MapScreenState extends State<MapScreen> {
  List<model.Location>? _locatioPoints;

  @override
  void initState() {
    super.initState();
    _fetchLocationPoints();
  }

  Future<void> _fetchLocationPoints() async {
    var pathId = widget.path.id;
    final url = Uri.parse('https://recess-mop-awoke.ngrok-free.dev/api/LocationPoint/location/search/pathId=$pathId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.session.token}', // JWT do Header!
          'ngrok-skip-browser-warning': '1' 
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        List<model.Location> locationPoints = [];
        for (var lp in data) {
          locationPoints.add(model.Location.fromJson(lp));
        }

        setState(() {
          _locatioPoints = locationPoints;
        });
      }
    } catch (e, stacktrace) {
      print("Erro ao buscar caminhos: $e");
      print(stacktrace);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_locatioPoints == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (_locatioPoints!.isEmpty) {
      return const Center(
        child: Text("Nenhum caminho encontrado para este carro"),
      );
    } else {
      List<LatLng> geopoints = [for(model.Location p in _locatioPoints!) LatLng(p.latitude, p.longitude)];
      var initialCenter = LatLng(_locatioPoints!.first.latitude, _locatioPoints!.first.longitude);
      return Scaffold(
        appBar: AppBar(title: Text("Visualizando rota ${widget.path.id}")),
        body: FlutterMap(
          options: MapOptions(initialCenter: initialCenter),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.fleettrackerAdminApp',
            ),
            PolylineLayer(
              polylines: [Polyline(
                points: geopoints,
                color: Colors.blue,
                strokeWidth: 5.0
              )]
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: geopoints.last, 
                  child: const Icon(Icons.location_on, color: Colors.green),
                  width: 40,
                  height: 40
                ),
                Marker(
                  point: geopoints.first, 
                  child: const Icon(Icons.location_on, color: Colors.red),
                  width: 40,
                  height: 40
                ),
                  
              ]
            )
          ]
        ),
      );
    }
  }
}