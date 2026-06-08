import 'dart:convert';

import 'package:fleettracker_admin_app/mapscreen.dart';
import 'package:fleettracker_admin_app/usersession.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'classes.dart';

class PathsList extends StatefulWidget {
  final VoidCallback onLogout;
  final UserSession session;
  final Car car;

  const PathsList({
    super.key,
    required this.onLogout,
    required this.session,
    required this.car
  });

  @override
  State<StatefulWidget> createState() {
    return _PathsListState();
  }
}

class _PathsListState extends State<PathsList> {
  List<Path>? _paths;

  @override
  void initState() {
    super.initState();
    _fetchPaths();
  }

  Future<void> _fetchPaths() async {
    var carId = widget.car.id;
    final url = Uri.parse('https://recess-mop-awoke.ngrok-free.dev/api/Path/search/id=$carId');

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

        List<Path> paths = [];
        for (var path in data) {
          paths.add(Path.fromJson(path));
        }

        setState(() {
          _paths = paths;
        });
      }
    } catch (e) {
      print("Erro ao buscar caminhos: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyWidget;

    if (_paths == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (_paths!.isEmpty) {
      bodyWidget = Center(
        child: Text("Nenhum caminho encontrado para este carro"),
      );
    } else {
      bodyWidget = ListView.builder(
            itemCount: _paths!.length,
            itemBuilder: (context, index) {
            Path p = _paths![index];
            return ListTile(
              leading: Icon(Icons.map),
              title: Text("${p.createdAt.day}/${p.createdAt.month}/${p.createdAt.year}"),
              subtitle: Text("${p.createdAt.hour}:${p.createdAt.minute}"),
              onTap: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => MapScreen(
                    session: widget.session, 
                    onLogout: widget.onLogout, 
                    path: p)
                    )
                  );
              },
          );
        }
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text("Caminhos de: ${widget.car.model} - ${widget.car.plate}")),
      body: bodyWidget,
    );
  }
}