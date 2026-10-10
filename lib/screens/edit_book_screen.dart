import 'package:flutter/material.dart';

class EditBookScreen extends StatelessWidget {
  const EditBookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Добавить книгу')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Добавьте книгу в свою библиотеку', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 20),
          const TextField(decoration: InputDecoration(labelText: 'Название книги', border: OutlineInputBorder())),
          const SizedBox(height: 16),
          const TextField(decoration: InputDecoration(labelText: 'Автор', border: OutlineInputBorder())),
          const SizedBox(height: 16),
          const TextField(decoration: InputDecoration(labelText: 'Жанр', border: OutlineInputBorder())),
          const SizedBox(height: 16),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Состояние книги',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.arrow_drop_down),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.check),
            label: const Text('Готово'),
          ),
        ],
      ),
    );
  }
}
