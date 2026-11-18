import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/loans_model.dart';

class MyLoansScreen extends StatelessWidget {
  const MyLoansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // 1) ПОКАЗЫВАЕШЬ и следишь — watch, в build
    final loansModel = context.watch<LoansModel>();
    final borrowedLoans = loansModel.items;

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
            const Center(
              child: Text(
                'Нет выданных книг',
                style: TextStyle(color: Colors.grey),
              ),
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
                            onPressed: () {
                              context.read<LoansModel>().remove(loan.id);
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
        ),
      ),
    );
  }
}
