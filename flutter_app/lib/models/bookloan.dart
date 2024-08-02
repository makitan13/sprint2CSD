class BookLoan {
  final int book;
  final int member;
  final int librarian;
  final DateTime loanDate;
  final DateTime dueDate;
  final DateTime? returnDate;

  BookLoan({
    required this.book,
    required this.member,
    required this.librarian,
    required this.loanDate,
    required this.dueDate,
    this.returnDate,
  });

  factory BookLoan.fromJson(Map<String, dynamic> json) {
    return BookLoan(
      book: json['book'],
      member: json['member'],
      librarian: json['librarian'],
      loanDate: DateTime.parse(json['loan_date']),
      dueDate: DateTime.parse(json['due_date']),
      returnDate: json['return_date'] != null
          ? DateTime.parse(json['return_date'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'book': book,
      'member': member,
      'librarian': librarian,
      'loan_date':
          loanDate.toIso8601String().split('T').first, // Format as YYYY-MM-DD
      'due_date':
          dueDate.toIso8601String().split('T').first, // Format as YYYY-MM-DD
      'return_date': returnDate
          ?.toIso8601String()
          .split('T')
          .first, // Format as YYYY-MM-DD
    };
  }
}
