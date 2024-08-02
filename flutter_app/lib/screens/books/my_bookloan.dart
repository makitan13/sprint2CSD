import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_app/models/current_bookloan.dart';
import 'package:flutter_app/services/api_service.dart';
import 'package:flutter_app/services/auth_provider.dart';

class MyBookloan extends StatefulWidget {
  @override
  _MyBookloanState createState() => _MyBookloanState();
}

class _MyBookloanState extends State<MyBookloan> {
  late Future<List<CurrentBookloan>> futureBookLoans;

  @override
  void initState() {
    super.initState();
    final username = Provider.of<AuthProvider>(context, listen: false).username;
    if (username != null) {
      futureBookLoans = fetchMyBookloan(username);
    } else {
      // Handle case where username is not available
      futureBookLoans = Future.error('Username not available');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Book Loans'),
      ),
      body: FutureBuilder<List<CurrentBookloan>>(
        future: futureBookLoans,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Failed to load book loans: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No book loans available.'));
          } else {
            List<CurrentBookloan> bookLoans = snapshot.data!;
            return ListView.builder(
              itemCount: bookLoans.length,
              itemBuilder: (context, index) {
                final loan = bookLoans[index];
                final dueDate = loan.dueDate;
                final loanDate = loan.loanDate;
                final returnDate =
                    loan.returnDate != null ? loan.returnDate! : null;

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loan.bookTitle ?? 'Unknown Title',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text('Member: ${loan.memberName}'),
                        Text('Librarian: ${loan.librarianName}'),
                        Text('Loan Date: ${loanDate}'),
                        Text('Due Date: ${dueDate}'),
                        Text(
                          'Return Date: ${returnDate ?? 'Not returned'}',
                          style: TextStyle(
                            fontWeight: returnDate == null
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Days Overdue: ${_calculateDaysOverdue(dueDate)} Days',
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  int _calculateDaysOverdue(String dueDate) {
    final dueDateTime = DateTime.parse(dueDate);
    final currentDate = DateTime.now();
    final difference = currentDate.difference(dueDateTime).inDays;
    return difference > 0 ? difference : 0; // Return 0 if not overdue
  }
}
