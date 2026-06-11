import 'dart:async';
import 'dart:convert';
import 'package:fleettracker_admin_app/usersession.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/nfc_manager_android.dart';
import 'package:fleettracker_admin_app/customdrawer.dart';
import 'package:http/http.dart' as http;

class RegisterCarPage extends StatefulWidget {
  final UserSession session;
  final VoidCallback onLogout;

  RegisterCarPage({super.key, required this.session, required this.onLogout});

  @override
  State<StatefulWidget> createState() {
    return _RegisterCarPageState();
  }
}

class _RegisterCarPageState extends State<RegisterCarPage> {
  String _tagUid = "";
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _plateController = TextEditingController();

  Future<String?> _lerNfc() async {
    NfcAvailability isAvailable = await NfcManager.instance.checkAvailability();
    if (isAvailable != NfcAvailability.enabled) {
      throw Exception(
        "Falha na leitura da tag. Leitor NFC desabilitado ou faltando",
      );
    }

    final completer = Completer<String?>();
    NfcManager.instance.startSession(
      pollingOptions: {NfcPollingOption.iso14443},
      onDiscovered: (NfcTag tag) async {
        List<int>? rawBytes;

        final nfca = NfcAAndroid.from(tag);

        if (nfca != null) {
          rawBytes = nfca.tag.id.toList();
        }

        if (rawBytes != null) {
          final String hex = rawBytes
              .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
              .join()
              .toUpperCase();
          if (!completer.isCompleted) {
            completer.complete(hex);
            await NfcManager.instance.stopSession();
          } else {
            await NfcManager.instance.stopSession();
          }
        }
      },
    );

    return completer.future.timeout(
      const Duration(seconds: 5),
      onTimeout: () async {
        print("nenhuma tag encontrada");
        await NfcManager.instance.stopSession();
        return null;
      },
    );
  }

  Future<void> _registerCar(String? tagUid) async {
    final url = Uri.parse(
      'https://recess-mop-awoke.ngrok-free.dev/api/Car/Cadastrar',
    );

    try {
      final reponse = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': '1',
        },
        body: jsonEncode({
          'tagUid': tagUid,
          'model': _modelController.text,
          'plate': _plateController.text.toUpperCase(),
        }),
      );

      if (reponse.statusCode == 201) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("carro cadastrado com sucesso")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao logar: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Cadastrar Veículo",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            onPressed: widget.onLogout,
            icon: Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      drawer: CustomDrawer(session: widget.session, onLogout: widget.onLogout),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _modelController,
              decoration: InputDecoration(
                labelText: "Modelo do Veículo",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.directions_car),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _plateController,
              decoration: InputDecoration(
                labelText: "Placa do Veículo",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.confirmation_number),
              ),
            ),
            SizedBox(height: 25),
            Text(_tagUid),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: () async {
                String? tagUid = await _lerNfc();
                setState(() {
                  _tagUid = tagUid ?? "Leitura falhou, tente novamente";
                });
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text("Ler tag NFC", style: TextStyle(fontSize: 16)),
            ),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: () async {
                _registerCar(_tagUid);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text("ENVIAR", style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
