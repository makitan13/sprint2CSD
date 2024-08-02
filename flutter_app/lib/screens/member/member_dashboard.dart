import 'package:flutter/material.dart';
import '../books/base_page.dart'; // Import widget BasePage

class MemberDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const BasePage(
      title: 'Member Dashboard ',
      body: Center(
        child: Text(
          'Member Dashboard Page',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
