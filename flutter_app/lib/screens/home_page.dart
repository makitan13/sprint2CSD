import 'package:flutter/material.dart';
import 'member/login_member_page.dart'; // Import halaman login member
import 'librarian/login_librarian_page.dart'; // Import halaman login librarian

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to the Library'),
        backgroundColor: Colors.grey,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to the Library!',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 40.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginMemberPage(),
                  ),
                );
              },
              child: Text('Member Login'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginLibrarianPage(),
                  ),
                );
              },
              child: Text('Librarian Login'),
            ),
          ],
        ),
      ),
    );
  }
}
