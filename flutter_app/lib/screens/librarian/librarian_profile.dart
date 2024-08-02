import 'package:flutter/material.dart';

// Profile page for the menu option
class LibrarianProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Text(
          'Profile Page',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
