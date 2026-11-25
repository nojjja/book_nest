import 'package:flutter/material.dart';
import '../data/book.dart';
import 'book_shelf_row.dart';

/// Совместимая обёртка над архивной строкой книжной полки
class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback? onTap;

  const BookCard({
    super.key,
    required this.book,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BookShelfRow(
      book: book,
      onTap: onTap ?? () {},
    );
  }
}
