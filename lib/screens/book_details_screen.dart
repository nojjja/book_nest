import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../data/loan.dart';
import '../models/books_model.dart';
import '../models/loans_model.dart';
import '../widgets/status_badge.dart';

class BookDetailsScreen extends StatelessWidget {
  final String id; // В адресе путешествует только идентификатор

  const BookDetailsScreen({super.key, required this.id});

  Future<void> _deleteBook(BuildContext context, String bookId, String title) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Удалить книгу?'),
        content: Text('Книга «$title» будет удалена из каталога.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );

    if (ok != true || !context.mounted) return;

    final error = await context.read<BooksModel>().remove(bookId);
    if (!context.mounted) return; // экран может умереть, пока «запрос» летит

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    context.pop(); // объекта больше нет — его экран уходит из стека
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // 6.4: Детали ищут через модель
    final model = context.watch<BooksModel>();
    final book = model.byId(id);

    if (book == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Книга')),
        body: Center(
          child: model.isLoading
              ? const CircularProgressIndicator() // список ещё грузится
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Запись не существует'),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () => context.pop(),
                      child: const Text('Вернуться назад'),
                    ),
                  ],
                ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Удалить книгу',
            onPressed: () => _deleteBook(context, book.id, book.title),
          ),
        ],
      ),
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
                    ? () async {
                        final draftLoan = Loan(
                          id: '',
                          bookTitle: book.title,
                          borrowerName: 'Надежда',
                          dueDate: '10.12.2026',
                          status: 'Взята',
                        );
                        // 2) ДЕЙСТВУЕШЬ — read, в callback-е
                        final error = await context.read<LoansModel>().add(draftLoan);
                        if (!context.mounted) return;
                        if (error != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error)),
                          );
                          return;
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Запрос отправлен, книга добавлена в ваши обмены!'),
                          ),
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
