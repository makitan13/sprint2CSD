import 'package:flutter/material.dart';
import 'package:flutter_app/screens/books/book_list.dart';
import 'package:flutter_app/screens/books/book_loan_page.dart';
import 'package:flutter_app/services/auth_provider.dart';
import 'package:provider/provider.dart';
import 'screens/home_page.dart';
import 'screens/member/login_member_page.dart';
import 'screens/librarian/login_librarian_page.dart';
import 'screens/librarian/register_librarian.dart';
import 'screens/librarian/librarian_profile.dart';
import 'screens/librarian/librarian_dashboard.dart';
import 'screens/member/member_dashboard.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
        routes: {
          '/homepage': (context) => HomePage(),
          '/login/member': (context) => LoginMemberPage(),
          '/login/librarian': (context) => LoginLibrarianPage(),
          '/register/librarian': (context) => RegistrationLibrarianPage(),
          '/profile': (context) => LibrarianProfilePage(),
          '/librarian/dashboard': (context) => LibrarianDashboard(),
          '/member/dashboard': (context) => MemberDashboard(),
          '/book-list': (context) => BookListPage(),
          '/bookloan': (context) => BookLoanPage()
        },
      ),
    );
  }
}
