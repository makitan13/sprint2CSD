import 'package:flutter/material.dart';
import 'package:flutter_app/screens/books/book_list.dart';
import 'package:flutter_app/screens/books/bookloan_form.dart';
import 'package:flutter_app/screens/books/my_bookloan.dart';
import 'package:flutter_app/screens/profile.dart';
import 'package:flutter_app/services/auth_provider.dart';
import 'package:flutter_app/services/auth_service.dart';
import 'package:provider/provider.dart';

class BasePage extends StatefulWidget {
  final String title;
  final Widget body;

  const BasePage({
    Key? key,
    required this.title,
    required this.body,
  }) : super(key: key);

  @override
  _BasePageState createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  bool _isBookloanExpanded = false;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'Profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              } else if (value == 'Logout') {
                try {
                  final refreshToken = authProvider.refresh;
                  if (refreshToken != null) {
                    await logout(refreshToken);
                    authProvider.clearTokens();
                    Navigator.pushReplacementNamed(context, '/homepage');
                  }
                } catch (e) {
                  // Handle the error appropriately
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to logout')),
                  );
                }
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Profile', 'Logout'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
            icon: Icon(Icons.person),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 156, 173, 187),
              ),
              child: Text(
                'Library Management',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Book List'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BookListPage()),
                );
              },
            ),
            ListTile(
              title: Text('Bookloan'),
              trailing: IconButton(
                icon: Icon(
                  _isBookloanExpanded ? Icons.expand_less : Icons.expand_more,
                ),
                onPressed: () {
                  setState(() {
                    _isBookloanExpanded = !_isBookloanExpanded;
                  });
                },
              ),
            ),
            if (_isBookloanExpanded)
              Column(
                children: [
                  ListTile(
                    title: const Text(
                      'Start Loan Book',
                      style: TextStyle(color: Colors.grey, fontSize: 14.0),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BookloanForm()),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text(
                      'My Bookloan Overdue List',
                      style: TextStyle(color: Colors.grey, fontSize: 14.0),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyBookloan()),
                      );
                    },
                  ),
                ],
              ),
            // Tambahkan ListTile lain untuk menu lainnya di sini
          ],
        ),
      ),
      body: widget.body,
    );
  }
}
