import 'dart:convert';
import 'package:fleettracker_admin_app/classes.dart';
import 'package:fleettracker_admin_app/pathslist.dart';
import 'package:fleettracker_admin_app/usersession.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CarsList extends StatefulWidget {
  final UserSession session;
  final VoidCallback onLogout;

  const CarsList({
    super.key,
    required this.session,
    required this.onLogout
  });

  @override
  State<StatefulWidget> createState() {
    return _CarsListState();
  }
}

class _CarsListState extends State<CarsList> {
  List<Car>? _cars;

  @override
  void initState() {
    super.initState();
    _fetchCars();
  }

  Future<void> _fetchCars() async {
    final url = Uri.parse('https://recess-mop-awoke.ngrok-free.dev/api/Car/Buscar');
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

        List<Car> cars = [];
        for (var car in data) {
          cars.add(Car.fromJson(car));
        }

        setState(() {
          _cars = cars;
        });
      }
    } catch (e) {
      print("Erro ao chamar api: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cars == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_cars!.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_cars!.isEmpty) {
      return const Center(
        child: Text("Nenhum carro encontrado"),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchCars, 
      child: ListView.builder(
      itemCount: _cars!.length,
      itemBuilder: (context, index) {
        Car c = _cars![index];
        return ListTile(
          leading: Icon(Icons.directions_car),
          title: Text(c.model),
          subtitle: Text("Placa: ${c.plate} Id: ${c.id}"),
          trailing: Icon(Icons.arrow_forward),
          onTap: () {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => PathsList(onLogout: widget.onLogout, session: widget.session, car: c))
              );
            },
          );
        }
      )
    );
  }
}