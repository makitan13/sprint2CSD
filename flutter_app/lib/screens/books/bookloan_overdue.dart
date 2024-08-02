import 'package:flutter/material.dart';
import 'package:flutter_app/models/overdue_book_loan.dart';
import 'package:flutter_app/services/api_service.dart';

class BookloanOverdue extends StatefulWidget {
  @override
  _OverdueBookLoanPageState createState() => _OverdueBookLoanPageState();
}

class _OverdueBookLoanPageState extends State<BookloanOverdue> {
  List<OverdueBookLoan> _loans = [];
  int _currentPage = 1;
  bool _isLoading = false;
  String? _nextPageUrl;
  String? _previousPageUrl;

  @override
  void initState() {
    super.initState();
    _fetchLoans();
  }

  Future<void> _fetchLoans() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await fetchOverdueBookLoans(_currentPage);
      setState(() {
        _loans = response['results'];
        _nextPageUrl = response['next'];
        _previousPageUrl = response['previous'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle error
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to load loans: $e')));
    }
  }

  void _loadNextPage() {
    if (_nextPageUrl != null) {
      setState(() {
        _currentPage++;
      });
      _fetchLoans();
    }
  }

  void _loadPreviousPage() {
    if (_previousPageUrl != null) {
      setState(() {
        _currentPage--;
      });
      _fetchLoans();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Overdue Book Loans'),
      ),
      body: Column(
        children: [
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    itemCount: _loans.length,
                    itemBuilder: (context, index) {
                      final loan = _loans[index];
                      return Card(
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                loan.bookTitle,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text('Member: ${loan.memberName}'),
                              Text('Librarian: ${loan.librarianName}'),
                              Text('Loan Date: ${loan.loanDate}'),
                              Text('Due Date: ${loan.dueDate}'),
                              Text.rich(
                                TextSpan(
                                  text: 'Return Date: ',
                                  children: [
                                    TextSpan(
                                      text: loan.returnDate ?? 'Not returned',
                                      style: TextStyle(
                                        fontWeight: loan.returnDate == null
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Text.rich(TextSpan(
                                text: 'OVERDUE',
                                style: TextStyle(
                                    fontWeight: loan.returnDate == null
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: Colors.red),
                              )),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed:
                      _previousPageUrl != null ? _loadPreviousPage : null,
                  child: Text('Previous'),
                ),
                ElevatedButton(
                  onPressed: _nextPageUrl != null ? _loadNextPage : null,
                  child: Text('Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
