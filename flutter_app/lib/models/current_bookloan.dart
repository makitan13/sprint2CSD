class CurrentBookloan {
  final int book;
  final int member;
  final int librarian;
  final String loanDate;
  final String dueDate;
  final String? returnDate;
  final String? bookTitle;
  final String? memberName;
  final String? librarianName;

  CurrentBookloan(
      {required this.book,
      required this.member,
      required this.librarian,
      required this.loanDate,
      required this.dueDate,
      this.returnDate,
      this.bookTitle,
      this.librarianName,
      this.memberName});

  factory CurrentBookloan.fromJson(Map<String, dynamic> json) {
    return CurrentBookloan(
        book: json['book'],
        member: json['member'],
        librarian: json['librarian'],
        loanDate: json['loan_date'],
        dueDate: json['due_date'],
        returnDate: json['return_date'],
        bookTitle: json['book_title'],
        memberName: json['member_name'],
        librarianName: json['librarian_name']);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'book': book,
      'member': member,
      'librarian': librarian,
      'loan_date': loanDate,
      'due_date': dueDate,
      'return_date': returnDate,
      'book_title': bookTitle,
      'member_name': memberName,
      'librarian_name': librarian
    };

    return data;
  }
}
