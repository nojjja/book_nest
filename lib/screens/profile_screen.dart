import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 20),

          Center(
            child: CircleAvatar(
              radius: 42,
              backgroundColor: scheme.primaryContainer,
              child: Text(
                'Н',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: scheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Center(
            child: Text(
              'Надежда',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),

          const SizedBox(height: 6),

          Center(
            child: Text(
              'nadezhda@example.com',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
          ),

          const SizedBox(height: 30),

          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.menu_book,
                    color: scheme.primary,
                  ),
                  title: const Text('Книги в библиотеке'),
                  trailing: const Text('8'),
                ),

                const Divider(height: 1),

                ListTile(
                  leading: Icon(
                    Icons.swap_horiz,
                    color: scheme.primary,
                  ),
                  title: const Text('Завершённые обмены'),
                  trailing: const Text('12'),
                ),

                const Divider(height: 1),

                ListTile(
                  leading: Icon(
                    Icons.star_outline,
                    color: scheme.primary,
                  ),
                  title: const Text('Рейтинг'),
                  trailing: const Text('4.8'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.settings_outlined),
                  title: const Text('Настройки'),
                  trailing: const Icon(Icons.chevron_right),
                ),

                const Divider(height: 1),

                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text('Помощь'),
                  trailing: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}