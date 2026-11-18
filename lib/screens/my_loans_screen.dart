import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/loans_model.dart';
import '../widgets/error_view.dart';

class MyLoansScreen extends StatelessWidget {
  const MyLoansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // 1) ПОКАЗЫВАЕШЬ и следишь — watch, в build
    final model = context.watch<LoansModel>();

    final Widget body;
    if (model.isLoading) {
      body = const Center(child: CircularProgressIndicator()); // 1) грузится
    } else if (model.error != null) {
      body = ErrorView(
        message: model.error!, // 2) упало
        onRetry: () => context.read<LoansModel>().load(), // read: действие
      );
    } else {
      final givenLoans = model.items.where((l) => l.status == 'Выдана').toList();
      final borrowedLoans = model.items.where((l) => l.status == 'Взята').toList();

      body = TabBarView(
        children: [
          // Вкладка 1: Выданные книги
          givenLoans.isEmpty
              ? const Center(
                  child: Text(
                    'Нет выданных книг',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: givenLoans.length,
                  itemBuilder: (context, index) {
                    final loan = givenLoans[index];
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
          borrowedLoans.isEmpty
              ? const Center(
                  child: Text(
                    'Нет взятых книг',
                    style: TextStyle(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: borrowedLoans.length,
                  itemBuilder: (context, index) {
                    final loan = borrowedLoans[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      child: ListTile(
                        leading: Icon(Icons.inbox_rounded, color: colorScheme.tertiary),
                        title: Text(loan.bookTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Взято у: ${loan.borrowerName}\nВернуть до: ${loan.dueDate}'),
                        isThreeLine: true,
                        trailing: OutlinedButton(
                          // 2) ДЕЙСТВУЕШЬ — read, в callback-е
                          onPressed: () async {
                            final error = await context.read<LoansModel>().remove(loan.id);
                            if (!context.mounted) return;
                            if (error != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(error)),
                              );
                              return;
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Книга успешно возвращена!')),
                            );
                          },
                          child: const Text('Вернуть'),
                        ),
                      ),
                    );
                  },
                ),
        ],
      );
    }

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
        body: body,
      ),
    );
  }
}
