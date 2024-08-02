import 'package:flutter/material.dart';
import '../books/base_page_librarian.dart'; // Import widget BasePage

class LibrarianDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const BasePageLibrarian(
      title: 'Librarian Dashboard ',
      body: Center(
        child: Text(
          'Librarian Dashboard Page',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
