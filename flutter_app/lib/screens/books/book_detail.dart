import 'package:flutter/material.dart';
import 'package:flutter_app/models/book.dart';

class BookDetailPage extends StatelessWidget {
  final Book book;

  BookDetailPage({required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar sampul buku
            book.coverImage != null
                ? Image.network(
                    book.coverImage!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.book,
                      size: 100,
                      color: Colors.grey[600],
                    ),
                  ),
            SizedBox(height: 16.0),
            // Judul buku
            Text(
              book.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
              ),
            ),
            SizedBox(height: 8.0),
            // Penulis buku
            Text(
              'Author: ${book.author}',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8.0),
            // Kategori buku
            Text(
              'Category: ${book.categoryName}',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8.0),
            // Kategori buku
            Text(
              'ISBN: ${book.isbn}',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8.0),
            // Kategori buku
            Text(
              'Published Date: ${book.publishedDate}',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16.0),
            // Deskripsi buku
            Text(
              'Description:',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey[600],
              ),
            ),
            Text(
              book.description ?? 'No description available',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
