import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/mock_book_repository.dart';
import 'data/mock_loan_repository.dart';
import 'data/mock_network_failure_controller.dart';
import 'data/network_failure_controller.dart';
import 'models/books_model.dart';
import 'models/loans_model.dart';
import 'router.dart';
import 'theme/app_theme.dart';

// main.dart — корень композиции: ЗДЕСЬ (и только здесь) выбирается источник
void main() {
  final bookRepository = MockBookRepository(); // на L5: вариант http — и всё
  final loanRepository = MockLoanRepository();
  final failureController = MockNetworkFailureController(
    books: bookRepository,
    loans: loanRepository,
  );

  runApp(
    MultiProvider(
      providers: [
        // леса демонстрации аварии (Задание 7) — исчезают на L5
        Provider<MockBookRepository>.value(value: bookRepository),
        Provider<MockLoanRepository>.value(value: loanRepository),
        Provider<NetworkFailureController>.value(value: failureController),
        ChangeNotifierProvider(
          create: (_) => BooksModel(bookRepository)..load(), // DI + старт
        ),
        ChangeNotifierProvider(
          create: (_) => LoansModel(loanRepository)..load(), // DI + старт
        ),
      ],
      child: const BookNestApp(), // MaterialApp.router — нетронут с L3
    ),
  );
}

class BookNestApp extends StatelessWidget {
  const BookNestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BookNest',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      routerConfig: router,
    );
  }
}
