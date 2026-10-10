import 'package:flutter/material.dart';
import '../data/mock_data.dart';
import '../widgets/book_card.dart';
import 'edit_book_screen.dart';

class MyLibraryScreen extends StatelessWidget {
  const MyLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BookNest — Моя библиотека'),
      ),
      body: Column(
        children: [
          // Поле поиска (на L2 — только статическая верстка)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Поиск книги или автора...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          // Визуальные фильтры по жанрам (статические на L2)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                'Все',
                'Программирование',
                'Антиутопия',
                'Образование',
                'Фантастика',
                'Классика'
              ].map((genre) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(genre),
                    selected: genre == 'Все',
                    onSelected: (_) {},
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          // Список книг с обращением к MockData.books
          Expanded(
            child: ListView.separated(
              itemCount: MockData.books.length,
              separatorBuilder: (_, __) => const SizedBox(height: 4),
              itemBuilder: (context, index) {
                return BookCard(book: MockData.books[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // На L2 переход через простой Navigator.push
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const EditBookScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}