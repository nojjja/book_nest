import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/mock_book_repository.dart';
import 'data/mock_loan_repository.dart';
import 'models/books_model.dart';
import 'models/loans_model.dart';
import 'router.dart';

// main.dart — корень композиции: ЗДЕСЬ (и только здесь) выбирается источник
void main() {
  final bookRepository = MockBookRepository(); // на L5: вариант http — и всё
  final loanRepository = MockLoanRepository();

  runApp(
    MultiProvider(
      providers: [
        // леса демонстрации аварии (Задание 7) — исчезают на L5
        Provider<MockBookRepository>.value(value: bookRepository),
        Provider<MockLoanRepository>.value(value: loanRepository),
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
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6D4C41),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      routerConfig: router,
    );
  }
}
