class OverdueBookLoan {
  final int id;
  final String bookTitle;
  final String memberName;
  final String librarianName;
  final String loanDate;
  final String dueDate;
  final String? returnDate;

  OverdueBookLoan({
    required this.id,
    required this.bookTitle,
    required this.memberName,
    required this.librarianName,
    required this.loanDate,
    required this.dueDate,
    this.returnDate,
  });

  factory OverdueBookLoan.fromJson(Map<String, dynamic> json) {
    return OverdueBookLoan(
      id: json['id'],
      bookTitle: json['book_title'],
      memberName: json['member_name'],
      librarianName: json['librarian_name'],
      loanDate: json['loan_date'],
      dueDate: json['due_date'],
      returnDate: json['return_date'],
    );
  }
}
