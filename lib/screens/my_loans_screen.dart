import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/book.dart';
import '../data/loan.dart';
import '../models/books_model.dart';
import '../models/loans_model.dart';
import '../theme/app_theme.dart';
import '../widgets/error_view.dart';
import '../widgets/loan_timeline_ruler.dart';
import '../widgets/perforated_line.dart';

class MyLoansScreen extends StatelessWidget {
  const MyLoansScreen({super.key});

  Future<void> _complete(BuildContext context, Loan loan) async {
    final loans = context.read<LoansModel>();
    final books = context.read<BooksModel>();
    final error = await loans.update(
      loan.copyWith(status: LoanStatus.completed),
    );
    if (!context.mounted) return;
    if (error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
      return;
    }

    final book = books.byId(loan.bookId);
    if (book != null && book.status == BookStatus.loaned) {
      final bookError = await books.update(
        book.copyWith(status: BookStatus.available),
      );
      if (!context.mounted) return;
      if (bookError != null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(bookError)));
        return;
      }
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Возврат отмечен в архиве.')));
  }

  @override
  Widget build(BuildContext context) {
    final loansModel = context.watch<LoansModel>();
    final booksModel = context.watch<BooksModel>();
    final allLoans = loansModel.items;
    final allBooks = booksModel.books;

    Book? bookFor(Loan loan) {
      for (final book in allBooks) {
        if (book.id == loan.bookId) return book;
      }
      return null;
    }

    final activeLoans = allLoans
        .where((loan) => loan.status == LoanStatus.active)
        .toList();
    final borrowed = activeLoans.where((loan) {
      final book = bookFor(loan);
      return loan.borrowerId == 'user1' &&
          book != null &&
          book.ownerId != 'user1';
    }).toList();
    final lent = activeLoans.where((loan) {
      final book = bookFor(loan);
      return loan.borrowerId != 'user1' &&
          book != null &&
          book.ownerId == 'user1';
    }).toList();
    final completed = allLoans
        .where((loan) => loan.status == LoanStatus.completed)
        .toList();

    Widget body;
    if (loansModel.isLoading || booksModel.isLoading) {
      body = const Center(
        child: CircularProgressIndicator(
          color: AppTheme.forestEmerald,
          strokeWidth: 1.5,
        ),
      );
    } else if (loansModel.error != null || booksModel.error != null) {
      body = ErrorView(
        message: loansModel.error ?? booksModel.error!,
        onRetry: () {
          context.read<LoansModel>().load();
          context.read<BooksModel>().load();
        },
      );
    } else {
      body = ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
        children: [
          Text(
            'ФОРМУЛЯР  /  03',
            style: AppTheme.mono(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppTheme.charcoalMuted,
            ),
          ),
          const SizedBox(height: 4),
          Text('Мои обмены', style: AppTheme.serifHeading(fontSize: 29)),
          const SizedBox(height: 22),
          _SectionHeading(
            title: 'ВЗЯТЫЕ МНОЙ',
            count: borrowed.length,
            color: AppTheme.forestEmerald,
          ),
          if (borrowed.isEmpty)
            const _EmptySection(text: 'Сейчас у вас нет взятых книг.')
          else
            for (final loan in borrowed)
              _LoanEntry(
                loan: loan,
                book: bookFor(loan),
                role: 'ВЛАДЕЛЕЦ',
                onComplete: () => _complete(context, loan),
                actionLabel: 'ВЕРНУТЬ КНИГУ',
              ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 18),
            child: PerforatedLine(),
          ),
          _SectionHeading(
            title: 'ВЫДАННЫЕ МНОЙ',
            count: lent.length,
            color: AppTheme.waxTerracotta,
          ),
          if (lent.isEmpty)
            const _EmptySection(text: 'Ваши книги сейчас никому не выданы.')
          else
            for (final loan in lent)
              _LoanEntry(
                loan: loan,
                book: bookFor(loan),
                role: 'ЧИТАТЕЛЬ',
                onComplete: () => _complete(context, loan),
                actionLabel: 'ОТМЕТИТЬ ВОЗВРАТ',
              ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 18),
            child: PerforatedLine(),
          ),
          _SectionHeading(
            title: 'ВОЗВРАЩЕНО В АРХИВ',
            count: completed.length,
            color: AppTheme.charcoalMuted,
          ),
          if (completed.isEmpty)
            const _EmptySection(text: 'Завершённых обменов пока нет.')
          else
            for (final loan in completed)
              _LoanEntry(
                loan: loan,
                book: bookFor(loan),
                role: 'ЗАВЕРШЕНО',
                completed: true,
              ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BOOKNEST  /  ФОРМУЛЯР',
          style: AppTheme.mono(fontSize: 10, fontWeight: FontWeight.w700),
        ),
      ),
      body: body,
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.title,
    required this.count,
    required this.color,
  });

  final String title;
  final int count;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTheme.mono(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Text(
          count.toString().padLeft(2, '0'),
          style: AppTheme.serifHeading(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _EmptySection extends StatelessWidget {
  const _EmptySection({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        text,
        style: AppTheme.sans(fontSize: 13, color: AppTheme.charcoalMuted),
      ),
    );
  }
}

class _LoanEntry extends StatelessWidget {
  const _LoanEntry({
    required this.loan,
    required this.book,
    required this.role,
    this.onComplete,
    this.actionLabel,
    this.completed = false,
  });

  final Loan loan;
  final Book? book;
  final String role;
  final VoidCallback? onComplete;
  final String? actionLabel;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    final participant = loan.borrowerName.isEmpty
        ? 'КНИГА № ${loan.bookId}'
        : 'УЧАСТНИК  /  ${loan.borrowerName}';
    final inventoryId = loan.bookId;
    final description = completed
        ? 'ЗАВЕРШЁННЫЙ ОБМЕН  /  ${loan.dueDate}'
        : '$participant  /  № $inventoryId';

    final color = completed ? AppTheme.charcoalMuted : AppTheme.charcoal;
    return Padding(
      padding: const EdgeInsets.only(top: 13),
      child: Container(
        padding: const EdgeInsets.only(bottom: 14),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppTheme.hairline, width: .7),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    book?.title ?? 'Книга из архива',
                    style: AppTheme.serifHeading(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  role,
                  style: AppTheme.mono(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    color: completed
                        ? AppTheme.charcoalMuted
                        : AppTheme.forestEmerald,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: AppTheme.sans(fontSize: 11, color: AppTheme.charcoalMuted),
            ),
            if (!completed) ...[
              const SizedBox(height: 13),
              LoanTimelineRuler(
                startDate: loan.startDate,
                dueDate: loan.dueDate,
              ),
              if (onComplete != null) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: onComplete,
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.waxTerracotta,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      actionLabel ?? 'ВЕРНУТЬ КНИГУ',
                      style: AppTheme.mono(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.waxTerracotta,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
