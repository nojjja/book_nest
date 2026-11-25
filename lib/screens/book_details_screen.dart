import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/book.dart';
import '../data/loan.dart';
import '../data/loan_actions.dart';
import '../models/books_model.dart';
import '../models/loans_model.dart';
import '../theme/app_theme.dart';
import '../widgets/book_cover.dart';
import '../widgets/error_view.dart';
import '../widgets/ex_libris_stamp.dart';

class BookDetailsScreen extends StatelessWidget {
  const BookDetailsScreen({super.key, required this.id});

  final String id;

  Future<void> _deleteBook(BuildContext context, Book book) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Убрать книгу из архива?', style: AppTheme.serifHeading()),
        content: Text(
          '«${book.title}» будет удалена из вашей полки.',
          style: AppTheme.sans(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('ОСТАВИТЬ'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('УДАЛИТЬ'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final error = await context.read<BooksModel>().remove(book.id);
    if (!context.mounted) return;
    if (error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    context.pop();
  }

  Future<void> _requestBook(BuildContext context, Book book) async {
    final error = await requestBookLoan(context, book);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          error ?? 'Запрос отправлен. Книга добавлена в ваши обмены.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final books = context.watch<BooksModel>();
    final loans = context.watch<LoansModel>();
    final book = books.byId(id);

    if (book == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Запись архива')),
        body: Center(
          child: books.isLoading
              ? const CircularProgressIndicator(color: AppTheme.forestEmerald)
              : books.error != null
              ? ErrorView(
                  message: books.error!,
                  onRetry: () => context.read<BooksModel>().load(),
                )
              : Text(
                  'Книга не найдена',
                  style: AppTheme.serifHeading(fontSize: 20),
                ),
        ),
      );
    }

    final isOwner = book.ownerId == 'user1';
    String? dueDate;
    for (final loan in loans.items) {
      if (loan.bookId == book.id && loan.status == LoanStatus.active) {
        dueDate = loan.dueDate;
        break;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'АРХИВНАЯ ЗАПИСЬ  /  ${book.id.padLeft(4, '0')}',
          style: AppTheme.mono(fontSize: 10, fontWeight: FontWeight.w700),
        ),
        actions: [
          if (isOwner)
            IconButton(
              tooltip: 'Редактировать',
              onPressed: () => context.push('/library/${book.id}/edit'),
              icon: const Icon(Icons.edit_outlined),
            ),
          if (isOwner)
            IconButton(
              tooltip: 'Удалить из архива',
              onPressed: () => _deleteBook(context, book),
              icon: const Icon(Icons.delete_outline),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 10, 22, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: BookCover(book: book, width: 210, height: 292)),
            const SizedBox(height: 25),
            Text(
              '${book.genre.toUpperCase()}  /  ИНВ. № ${book.id}',
              style: AppTheme.mono(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppTheme.charcoalMuted,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 9),
            Text(
              book.title,
              style: AppTheme.serifHeading(
                fontSize: 31,
                fontWeight: FontWeight.w700,
                height: 1.05,
              ),
            ),
            const SizedBox(height: 9),
            Text(
              'АВТОР  /  ${book.author}',
              style: AppTheme.sans(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 5),
            Text(
              'ЭКЗЕМПЛЯР ПРИНАДЛЕЖИТ  /  ${book.ownerId.toUpperCase()}',
              style: AppTheme.mono(fontSize: 9, color: AppTheme.charcoalMuted),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 19),
              child: Divider(height: 1, color: AppTheme.hairline),
            ),
            Center(
              child: ExLibrisStamp(
                status: book.status,
                dueDate: dueDate,
                inventoryId: book.id,
              ),
            ),
            const SizedBox(height: 27),
            Text(
              'КАТАЛОЖНОЕ ОПИСАНИЕ',
              style: AppTheme.mono(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppTheme.charcoalMuted,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              'Экземпляр из студенческого книгообмена. '
              'Жанр: ${book.genre}. Авторская запись: ${book.author}.',
              style: AppTheme.sans(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 26),
            if (!isOwner && book.status == BookStatus.available)
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => _requestBook(context, book),
                  icon: const Icon(Icons.bookmark_add_outlined),
                  label: const Text('ЗАПРОСИТЬ КНИГУ'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.forestEmerald,
                    foregroundColor: AppTheme.paper,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                ),
              )
            else if (!isOwner)
              Text(
                'ЭТОТ ЭКЗЕМПЛЯР УЖЕ ВЫДАН',
                style: AppTheme.mono(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.waxTerracotta,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
