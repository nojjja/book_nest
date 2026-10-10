import 'package:flutter/material.dart';

import '../data/mock_data.dart';
import '../widgets/book_card.dart';

class CommunityBooksScreen extends StatelessWidget {
  const CommunityBooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Книги сообщества')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Поиск по названию или автору',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                for (final genre in ['Все жанры', 'Программирование', 'Фантастика', 'Классика', 'Образование'])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(genre),
                      selected: genre == 'Все жанры',
                      onSelected: (_) {},
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: MockData.books.length,
              separatorBuilder: (_, __) => const SizedBox(height: 4),
              itemBuilder: (context, index) => BookCard(book: MockData.books[index]),
            ),
          ),
        ],
      ),
    );
  }
}
