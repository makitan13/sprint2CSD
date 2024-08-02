import 'dart:convert';
import 'package:flutter_app/models/current_bookloan.dart';
import 'package:http/http.dart' as http;
import '../../models/book.dart';
import '../models/category.dart';
import 'package:flutter_app/models/member.dart';
import 'package:flutter_app/models/librarian.dart';
import 'package:flutter_app/models/bookloan.dart';
import 'package:flutter_app/models/overdue_book_loan.dart';

Future<List<Category>> fetchCategories() async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/api/category/'));

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((category) => Category.fromJson(category)).toList();
  } else {
    throw Exception('Failed to load categories');
  }
}

Future<List<Book>> fetchBooks() async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/api/books/'));
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((book) => Book.fromJson(book)).toList();
  } else {
    throw Exception('Failed to load books');
  }
}

Future<List<Member>> fetchMembers() async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/api/members/'));
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((member) => Member.fromJson(member)).toList();
  } else {
    throw Exception('Failed to load members');
  }
}

Future<List<Librarian>> fetchLibrarians() async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/api/librarians/'));
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse
        .map((librarian) => Librarian.fromJson(librarian))
        .toList();
  } else {
    throw Exception('Failed to load librarians');
  }
}

Future<List<BookLoan>> fetchBookloan() async {
  final response =
      await http.get(Uri.parse('http://127.0.0.1:8000/api/bookloans/'));
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((loan) => BookLoan.fromJson(loan)).toList();
  } else {
    throw Exception('Failed to load librarians');
  }
}

Future<List<Book>> fetchBooksByCategory(String category) async {
  final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/books/filter/category/$category'));

  if (response.statusCode == 200) {
    final List<dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse.map((bookJson) {
      return Book.fromJson(bookJson);
    }).toList();
  } else {
    throw Exception('Failed to load books');
  }
}

Future<List<Book>> searchBooks(String query) async {
  final response = await http
      .get(Uri.parse('http://127.0.0.1:8000/api/books/search/$query'));
  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((book) => Book.fromJson(book)).toList();
  } else {
    throw Exception('Failed to search books');
  }
}

Future<void> createBookLoan(BookLoan bookLoan) async {
  final response = await http.post(
    Uri.parse('http://127.0.0.1:8000/api/bookloans/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(bookLoan.toJson()),
  );

  if (response.statusCode != 201) {
    throw Exception('Failed to create book loan: ${response.body}');
  }
}

Future<List<CurrentBookloan>> fetchMyBookloan(String username) async {
  final response = await http.get(Uri.parse(
      'http://127.0.0.1:8000/api/member/bookloans_overdue/$username'));
  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((item) => CurrentBookloan.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load book loans');
  }
}

Future<Map<String, dynamic>> fetchOverdueBookLoans(int page) async {
  final response = await http.get(
    Uri.parse('http://127.0.0.1:8000/api/overdue-book-loan/?page=$page'),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    List<OverdueBookLoan> loans = (data['results'] as List)
        .map((loan) => OverdueBookLoan.fromJson(loan))
        .toList();
    return {
      'results': loans,
      'next': data['next'],
      'previous': data['previous'],
    };
  } else {
    throw Exception('Failed to load overdue book loans');
  }
}

Future<Map<String, dynamic>> fetchOutstandBookLoans(int page) async {
  final response = await http.get(
    Uri.parse('http://127.0.0.1:8000/api/outstanding-book-loan/?page=$page'),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    List<OverdueBookLoan> loans = (data['results'] as List)
        .map((loan) => OverdueBookLoan.fromJson(loan))
        .toList();
    return {
      'results': loans,
      'next': data['next'],
      'previous': data['previous'],
    };
  } else {
    throw Exception('Failed to load overdue book loans');
  }
}
