import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../data/mock_book_repository.dart';
import '../data/mock_loan_repository.dart';
import '../models/books_model.dart';
import '../models/loans_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Эфемерное состояние переключателя аварии (C7: setState)
  bool _simulateError = false;

  // Логика блокирующего решения выхода из аккаунта (C6)
  Future<void> _logout(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        title: const Text('Выйти из аккаунта?'),
        content: const Text('Вам придётся снова ввести логин и пароль.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx, false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogCtx, true),
            child: const Text('Да, выйти'),
          ),
        ],
      ),
    );

    if (ok == true && context.mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: colorScheme.primaryContainer,
              child: Icon(
                Icons.person,
                size: 50,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Надежда',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text('Студент • Технический Университет Молдовы'),
            const SizedBox(height: 24),

            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.book),
                    title: const Text('Моих книг в каталоге'),
                    trailing: Consumer<BooksModel>(
                      builder: (context, books, _) => Text(
                        '${books.myBooks.length}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.swap_horiz),
                    title: const Text('Активных обменов'),
                    trailing: Consumer<LoansModel>(
                      builder: (context, loans, _) => Text(
                        '${loans.count}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 9.2: Переключатель аварии — леса демонстрации
            Card(
              child: SwitchListTile(
                secondary: Icon(
                  Icons.wifi_off,
                  color: _simulateError ? colorScheme.error : colorScheme.onSurfaceVariant,
                ),
                title: const Text('Симулировать сбой сети'),
                subtitle: const Text('Спровоцировать ошибку сервера (Err)'),
                value: _simulateError,
                onChanged: (value) {
                  setState(() => _simulateError = value);
                  context.read<MockBookRepository>().simulateError = value;
                  context.read<MockLoanRepository>().simulateError = value;
                },
              ),
            ),

            const Spacer(),

            // Кнопка выхода из аккаунта
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () => _logout(context),
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  'Выйти из аккаунта',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
