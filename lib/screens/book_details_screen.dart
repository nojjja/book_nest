import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../widgets/status_badge.dart';

class BookDetailsScreen extends StatelessWidget {
  final String id; // В адресе путешествует только идентификатор

  const BookDetailsScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Шаг 2 ТЗ: Экран сам ищет свой объект по id
    final book = MockData.books.firstWhere(
      (b) => b.id == id,
      orElse: () => MockData.books.first,
    );

    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 140,
                height: 200,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.menu_book, size: 80, color: colorScheme.onPrimaryContainer),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              book.title,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Автор: ${book.author}', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text('Жанр: ${book.genre}', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 4),
            Text('Владелец: ${book.ownerId}', style: TextStyle(color: colorScheme.outline)),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Статус: ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                StatusBadge(status: book.status),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: book.status == 'Доступна'
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Запрос отправлен владельцу!')),
                        );
                      }
                    : null,
                icon: const Icon(Icons.handshake),
                label: const Text('Запросить книгу на время'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}