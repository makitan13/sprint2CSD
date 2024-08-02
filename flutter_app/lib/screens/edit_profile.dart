import 'package:flutter/material.dart';
import 'package:flutter_app/services/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  final String username;

  EditProfilePage({required this.username});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = true;
  String? _errorMessage;
  String? _typeMember;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/profile/${widget.username}'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      setState(() {
        _typeMember = responseData['type'];
        final profileData = responseData['data'];
        _firstNameController.text = profileData['first_name'];
        _lastNameController.text = profileData['last_name'];
        _emailController.text = profileData['email'];
        _usernameController.text = profileData['username'];
        _passwordController.text = profileData['password'];
        _isLoading = false;
      });
    } else {
      setState(() {
        _errorMessage = 'Failed to load profile.';
        _isLoading = false;
      });
    }
  }

  Future<void> _updateProfile() async {
    final response = await http.put(
      Uri.parse('http://127.0.0.1:8000/api/profile/${widget.username}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'first_name': _firstNameController.text,
        'last_name': _lastNameController.text,
        'email': _emailController.text,
        'username': _usernameController.text,
        'password': _passwordController.text,
      }),
    );
    if (response.statusCode == 200) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.setUsername(_usernameController.text);
      Navigator.pushReplacementNamed(
          context, '/profile'); // Navigate back to the profile page
    } else {
      setState(() {
        _errorMessage = 'Failed to update profile.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 50.0,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'First Name: ',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  TextField(
                    controller: _firstNameController,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Last Name: ',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  TextField(
                    controller: _lastNameController,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Email: ',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  TextField(
                    controller: _emailController,
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Username: ',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  TextField(
                    controller: _usernameController,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Type: ${_typeMember ?? ''}',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Color.fromARGB(255, 4, 0, 255),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: _updateProfile,
                        child: Text('Save'),
                      ),
                      if (_errorMessage != null) ...[
                        SizedBox(height: 16.0),
                        Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
