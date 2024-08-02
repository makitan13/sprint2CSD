import 'package:flutter/material.dart';
import 'package:flutter_app/screens/edit_profile.dart';
import 'package:flutter_app/screens/librarian/librarian_change_password.dart';
import 'package:flutter_app/screens/member/member_change_password.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:flutter_app/services/auth_provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = true;
  Map<String, dynamic>? _profileData;
  String? _errorMessage;
  String? _typeMember;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final username = authProvider.username;

    if (username == null) {
      setState(() {
        _errorMessage = 'Username not found in session.';
        _isLoading = false;
      });
      return;
    }

    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/profile/$username'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      setState(() {
        _typeMember = responseData['type'];
        _profileData = responseData['data'];
        _isLoading = false;
      });
    } else {
      setState(() {
        _errorMessage = 'Failed to load profile.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
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
                        'First Name: ${_profileData?['first_name'] ?? ''}',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Last Name: ${_profileData?['last_name'] ?? ''}',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Email: ${_profileData?['email'] ?? ''}',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Username: ${_profileData?['username'] ?? ''}',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      SizedBox(height: 8.0),
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
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditProfilePage(
                                      username:
                                          _profileData?['username'] ?? ''),
                                ),
                              );
                            },
                            child: Text('Edit Profile'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Implement change password functionality
                              if (_typeMember == "Member") {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MemberChangePassword(),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        LibrarianChangePassword(),
                                  ),
                                );
                              }
                            },
                            child: Text('Change Password'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
    );
  }
}
