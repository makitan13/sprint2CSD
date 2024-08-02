import 'package:flutter/material.dart';
import 'package:flutter_app/models/bookloan.dart';
import 'package:flutter_app/models/book.dart';
import 'package:flutter_app/models/member.dart';
import 'package:flutter_app/models/librarian.dart';
import 'package:flutter_app/services/api_service.dart';

class BookLoanPage extends StatefulWidget {
  @override
  _BookLoanPageState createState() => _BookLoanPageState();
}

class _BookLoanPageState extends State<BookLoanPage> {
  late Future<List<BookLoan>> futureBookLoans;
  late Future<List<Book>> futureBooks;
  late Future<List<Member>> futureMembers;
  late Future<List<Librarian>> futureLibrarians;

  Map<int, String> bookTitles = {};
  Map<int, String> memberNames = {};
  Map<int, String> librarianNames = {};

  @override
  void initState() {
    super.initState();
    futureBookLoans = fetchBookloan();
    futureBooks = fetchBooks();
    futureMembers = fetchMembers();
    futureLibrarians = fetchLibrarians();

    futureBooks.then((books) {
      setState(() {
        bookTitles = {for (var book in books) book.id: book.title};
      });
    });

    futureMembers.then((members) {
      setState(() {
        memberNames = {for (var member in members) member.id: member.fullName};
      });
    });

    futureLibrarians.then((librarians) {
      setState(() {
        librarianNames = {
          for (var librarian in librarians) librarian.id: librarian.fullName
        };
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Loans'),
      ),
      body: FutureBuilder<List<BookLoan>>(
        future: futureBookLoans,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Failed to load book loans: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No book loans found.'));
          } else {
            List<BookLoan> bookLoans = snapshot.data!;
            return ListView.builder(
              itemCount: bookLoans.length,
              itemBuilder: (context, index) {
                final loan = bookLoans[index];
                final bookTitle = bookTitles[loan.book] ?? 'Unknown Book';
                final memberName = memberNames[loan.member] ?? 'Unknown Member';
                final librarianName =
                    librarianNames[loan.librarian] ?? 'Unknown Librarian';

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bookTitle,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text('Member: $memberName'),
                        Text('Librarian: $librarianName'),
                        Text(
                            'Loan Date: ${loan.loanDate.toLocal().toString().split(' ')[0]}'),
                        Text(
                            'Due Date: ${loan.dueDate.toLocal().toString().split(' ')[0]}'),
                        Text(
                          'Return Date: ${loan.returnDate?.toLocal().toString().split(' ')[0] ?? 'Not returned'}',
                          style: TextStyle(
                            fontWeight: loan.returnDate == null
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          _calculateDaysOverdue(loan.dueDate) > 0
                              ? 'Days Overdue: ${_calculateDaysOverdue(loan.dueDate)} Days'
                              : 'Days Left: ${-_calculateDaysOverdue(loan.dueDate)} Days',
                          style: TextStyle(
                              color: _calculateDaysOverdue(loan.dueDate) > 0
                                  ? Colors.red
                                  : const Color.fromARGB(255, 173, 160, 39),
                              fontWeight: FontWeight.bold),
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

  int _calculateDaysOverdue(DateTime dueDate) {
    final currentDate = DateTime.now();
    return currentDate.difference(dueDate).inDays;
  }
}
