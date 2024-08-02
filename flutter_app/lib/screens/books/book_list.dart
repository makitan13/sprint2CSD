import 'package:flutter/material.dart';
import 'package:flutter_app/models/book.dart';
import 'package:flutter_app/models/category.dart';
import 'package:flutter_app/screens/books/book_detail.dart';
import 'package:flutter_app/screens/books/book_search_delegate.dart';
import 'package:flutter_app/services/api_service.dart';

class BookListPage extends StatefulWidget {
  @override
  _BookListPageState createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  late Future<List<Book>> futureBooks;
  late Future<List<Category>> futureCategories;
  String selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    futureBooks = fetchBooks();
    futureCategories = fetchCategories();
  }

  void _filterBooks(String category) {
    setState(() {
      if (category == 'All') {
        futureBooks = fetchBooks();
      } else {
        futureBooks = fetchBooksByCategory(category);
      }
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Books List'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: BookSearchDelegate(),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          FutureBuilder<List<Category>>(
            future: futureCategories,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              List<Category> categories = snapshot.data!;
              return DropdownButton<String>(
                value: selectedCategory,
                items: ['All', ...categories.map((c) => c.categoryName)]
                    .map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  _filterBooks(newValue!);
                },
              );
            },
          ),
          Expanded(
            child: FutureBuilder<List<Book>>(
              future: futureBooks,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Failed to load books: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No books available.'));
                } else {
                  List<Book> books = snapshot.data!;
                  return ListView.builder(
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final book = books[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookDetailPage(book: book),
                            ),
                          );
                        },
                        child: Card(
                          margin: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      8.0), // Menambahkan sudut bundar
                                  child: book.coverImage != null
                                      ? Image.network(
                                          book.coverImage!,
                                          width: 120,
                                          height: 180,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          width: 120,
                                          height: 180,
                                          color: Colors.grey[300],
                                          child: Icon(
                                            Icons.book,
                                            size: 100,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                ),
                                SizedBox(width: 16.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        book.title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      SizedBox(height: 4.0),
                                      Text(
                                        book.author,
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 16.0,
                                        ),
                                      ),
                                      SizedBox(height: 4.0),
                                      Text(
                                        book.categoryName,
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
