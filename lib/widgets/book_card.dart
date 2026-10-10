import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import 'status_badge.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback? onTap; // Наследие L2: гибкий callback для нажатия

  const BookCard({
    super.key,
    required this.book,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: colorScheme.primary,
          child: Text(
            book.title.isNotEmpty ? book.title[0] : '?',
            style: TextStyle(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          book.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${book.author} • ${book.genre}'),
        trailing: StatusBadge(status: book.status),
      ),
    );
  }
}