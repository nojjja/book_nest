import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import '../models/books_model.dart';
import '../models/loans_model.dart';
import 'book.dart';
import 'loan.dart';

Future<String?> requestBookLoan(BuildContext context, Book book) async {
  if (book.status != BookStatus.available) {
    return 'Эта книга уже выдана.';
  }

  final loans = context.read<LoansModel>();
  final books = context.read<BooksModel>();
  final alreadyRequested = loans.items.any(
    (loan) =>
        loan.bookId == book.id &&
        loan.borrowerId == 'user1' &&
        loan.status == LoanStatus.active,
  );
  if (alreadyRequested) return 'Запрос на эту книгу уже отправлен.';

  final start = DateTime.now();
  final due = start.add(const Duration(days: 21));
  final loan = Loan(
    id: '',
    bookId: book.id,
    borrowerId: 'user1',
    borrowerName: 'Надежда',
    startDate: _formatDate(start),
    dueDate: _formatDate(due),
    status: LoanStatus.active,
  );

  final loanError = await loans.add(loan);
  if (loanError != null) return loanError;

  return books.update(book.copyWith(status: BookStatus.loaned));
}

String _formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day.$month.${date.year}';
}
