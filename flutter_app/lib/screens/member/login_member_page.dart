import 'package:flutter/material.dart';
import 'package:flutter_app/services/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import 'member_dashboard.dart'; // Halaman Dashboard Member
import 'register_member.dart'; // Halaman Register Member

class LoginMemberPage extends StatefulWidget {
  @override
  _LoginMemberPageState createState() => _LoginMemberPageState();
}

class _LoginMemberPageState extends State<LoginMemberPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter both username and password.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/login/member'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    final responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      final String token = responseData['refresh'];
      final String username = responseData['username'];

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.setTokens(token, username);

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MemberDashboard()),
        (Route<dynamic> route) => false,
      );
    } else {
      setState(() {
        _errorMessage =
            responseData['message'] ?? 'Invalid Username or Password.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Member Login'),
        backgroundColor: Colors.grey,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Member Login',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24.0),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: Text('Login'),
                  ),
            if (_errorMessage != null) ...[
              SizedBox(height: 16.0),
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
            ],
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RegistrationMemberPage()),
                );
              },
              child: Text('Belum pernah login? Daftar sekarang'),
            ),
          ],
        ),
      ),
    );
  }
}
