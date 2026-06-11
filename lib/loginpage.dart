import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'usersession.dart';

class LoginPage extends StatefulWidget {
  final Function(UserSession) onLoginSuccess;

  const LoginPage({super.key, required this.onLoginSuccess});

  @override
  State<LoginPage> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool loading = false;

  Future<void> loginComBackend() async {
    final url = Uri.parse(
      'https://recess-mop-awoke.ngrok-free.dev/api/User/login',
    );

    try {
      setState(() => loading = true);

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'ngrok-skip-browser-warning': '1',
        },
        body: jsonEncode({
          'email': _emailController.text.trim(),
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        //final data = jsonDecode(response.body);
        final String token =
            response.body; // Mapeie conforme a resposta da sua LoginUseCase

        final session = UserSession(
          email: _emailController.text.trim(),
          token: token,
        );

        widget.onLoginSuccess(session);
      } else {
        throw Exception("Usuário ou senha inválidos.");
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao logar: $e")));
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/login_background1.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.8),
              BlendMode.darken,
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Center(
            child: loading
                ? const CircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 70),
                      Transform.scale(
                        scaleX: 1.3,
                        scaleY: 1,
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "Fleet",
                                style: TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              TextSpan(
                                text: "Tracker",
                                style: TextStyle(
                                  fontSize: 35,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 150),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                        style: TextStyle(color: Colors.white70),
                      ),
                      SizedBox(height: 12),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          labelStyle: TextStyle(color: Colors.white70),
                        ),
                        style: TextStyle(color: Colors.white70),
                        obscureText: true,
                      ),
                      SizedBox(height: 24),
                      FilledButton(
                        onPressed: loginComBackend,
                        child: Text("Entrar"),
                        style: FilledButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3),
                          ),
                          backgroundColor: Colors.blueGrey,
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
