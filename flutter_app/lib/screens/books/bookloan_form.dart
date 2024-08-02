import 'package:flutter/material.dart';
import 'package:flutter_app/models/book.dart';
import 'package:flutter_app/models/member.dart';
import 'package:flutter_app/models/librarian.dart';
import 'package:flutter_app/models/bookloan.dart';
import 'package:flutter_app/services/api_service.dart';

class BookloanForm extends StatefulWidget {
  @override
  _BookLoanPageState createState() => _BookLoanPageState();
}

class _BookLoanPageState extends State<BookloanForm> {
  late Future<List<Book>> futureBooks;
  late Future<List<Member>> futureMembers;
  late Future<List<Librarian>> futureLibrarians;

  Book? _selectedBook;
  Member? _selectedMember;
  Librarian? _selectedLibrarian;
  DateTime _loanDate = DateTime.now();
  DateTime _dueDate = DateTime.now().add(Duration(days: 3));

  @override
  void initState() {
    super.initState();
    futureBooks = fetchBooks();
    futureMembers = fetchMembers();
    futureLibrarians = fetchLibrarians();
  }

  Future<void> _selectDate(BuildContext context, bool isLoanDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isLoanDate ? _loanDate : _dueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != (isLoanDate ? _loanDate : _dueDate)) {
      setState(() {
        if (isLoanDate) {
          _loanDate = picked;
        } else {
          _dueDate = picked;
        }
      });
    }
  }

  void _submit() async {
    if (_selectedBook == null ||
        _selectedMember == null ||
        _selectedLibrarian == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please fill all fields')));
      return;
    }

    final bookLoan = BookLoan(
      book: _selectedBook!.id,
      member: _selectedMember!.id,
      librarian: _selectedLibrarian!.id,
      loanDate: _loanDate,
      dueDate: _dueDate,
    );

    try {
      await createBookLoan(bookLoan);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Book loan created successfully')));
      Navigator.pop(context);
    } catch (error) {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create book loan: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Book Loan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<List<Book>>(
              future: futureBooks,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No books available');
                }
                final books = snapshot.data!;
                return DropdownButton<Book>(
                  hint: Text('Select Book'),
                  value: _selectedBook,
                  onChanged: (Book? newValue) {
                    setState(() {
                      _selectedBook = newValue;
                    });
                  },
                  items: books.map((Book book) {
                    return DropdownMenuItem<Book>(
                      value: book,
                      child: Text(book.title),
                    );
                  }).toList(),
                );
              },
            ),
            FutureBuilder<List<Member>>(
              future: futureMembers,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No members available');
                }
                final members = snapshot.data!;
                return DropdownButton<Member>(
                  hint: Text('Select Member'),
                  value: _selectedMember,
                  onChanged: (Member? newValue) {
                    setState(() {
                      _selectedMember = newValue;
                    });
                  },
                  items: members.map((Member member) {
                    return DropdownMenuItem<Member>(
                      value: member,
                      child: Text(member.fullName),
                    );
                  }).toList(),
                );
              },
            ),
            FutureBuilder<List<Librarian>>(
              future: futureLibrarians,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Text('No librarians available');
                }
                final librarians = snapshot.data!;
                return DropdownButton<Librarian>(
                  hint: Text('Select Librarian'),
                  value: _selectedLibrarian,
                  onChanged: (Librarian? newValue) {
                    setState(() {
                      _selectedLibrarian = newValue;
                    });
                  },
                  items: librarians.map((Librarian librarian) {
                    return DropdownMenuItem<Librarian>(
                      value: librarian,
                      child:
                          Text('${librarian.firstName} ${librarian.lastName}'),
                    );
                  }).toList(),
                );
              },
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: Text(
                        'Loan Date: ${_loanDate.toLocal().toString().split(' ')[0]}'),
                    trailing: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context, true),
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text(
                        'Due Date: ${_dueDate.toLocal().toString().split(' ')[0]}'),
                    trailing: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context, false),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submit,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
