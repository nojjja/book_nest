import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../screens/book_details_screen.dart';
import 'status_badge.dart';

class BookCard extends StatelessWidget {
  final Book book;

  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        onTap: () {
          // На L2 навигация только через базовый Navigator.push
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => BookDetailsScreen(book: book)),
          );
        },
        leading: CircleAvatar(
          backgroundColor: colorScheme.primary,
          child: Text(
            book.title[0],
            style: TextStyle(color: colorScheme.onPrimary, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${book.author} • ${book.genre}'),
        trailing: StatusBadge(status: book.status),
      ),
    );
  }
}