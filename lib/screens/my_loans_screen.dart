import 'package:flutter/material.dart';
import '../data/mock_data.dart';

class MyLoansScreen extends StatelessWidget {
  const MyLoansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Мои обмены'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Выданные книги'),
              Tab(text: 'Взятые книги'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Вкладка 1: Выданные книги
            ListView.builder(
              itemCount: MockData.loans.where((l) => l.status == 'Выдана').length,
              itemBuilder: (context, index) {
                final loan = MockData.loans.where((l) => l.status == 'Выдана').toList()[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    leading: Icon(Icons.outbox_rounded, color: colorScheme.primary),
                    title: Text(loan.bookTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Кому: ${loan.borrowerName}\nВернуть до: ${loan.dueDate}'),
                    isThreeLine: true,
                    trailing: Chip(
                      label: Text(loan.status),
                      backgroundColor: colorScheme.secondaryContainer,
                    ),
                  ),
                );
              },
            ),
            // Вкладка 2: Взятые книги
            ListView.builder(
              itemCount: MockData.loans.where((l) => l.status == 'Взята').length,
              itemBuilder: (context, index) {
                final loan = MockData.loans.where((l) => l.status == 'Взята').toList()[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    leading: Icon(Icons.inbox_rounded, color: colorScheme.tertiary),
                    title: Text(loan.bookTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Взято у сокурсника\nВернуть до: ${loan.dueDate}'),
                    isThreeLine: true,
                    trailing: OutlinedButton(
                      onPressed: () {},
                      child: const Text('Вернуть'),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}