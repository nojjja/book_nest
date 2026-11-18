import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/books_model.dart';
import '../widgets/book_card.dart';
import '../widgets/error_view.dart';

class CommunityBooksScreen extends StatefulWidget {
  const CommunityBooksScreen({super.key});

  @override
  State<CommunityBooksScreen> createState() => _CommunityBooksScreenState();
}

class _CommunityBooksScreenState extends State<CommunityBooksScreen> {
  String _selectedGenre = 'Все жанры';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // watch в build (C7)
    final model = context.watch<BooksModel>();

    final Widget body;
    if (model.isLoading) {
      body = const Center(child: CircularProgressIndicator()); // 1) грузится
    } else if (model.error != null) {
      body = ErrorView(
        message: model.error!, // 2) упало
        onRetry: () => context.read<BooksModel>().load(), // read: действие
      );
    } else {
      final filteredBooks = model.books.where((b) {
        final matchesGenre = _selectedGenre == 'Все жанры' || b.genre == _selectedGenre;
        final query = _searchQuery.toLowerCase();
        final matchesQuery = b.title.toLowerCase().contains(query) ||
            b.author.toLowerCase().contains(query);
        return matchesGenre && matchesQuery;
      }).toList();

      body = Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
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
                for (final genre in [
                  'Все жанры',
                  'Программирование',
                  'Фантастика',
                  'Классика',
                  'Образование',
                  'Антиутопия'
                ])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(genre),
                      selected: _selectedGenre == genre,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedGenre = genre);
                        }
                      },
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filteredBooks.isEmpty
                ? const Center(
                    child: Text(
                      'Книги не найдены',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.separated(
                    itemCount: filteredBooks.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 4),
                    itemBuilder: (context, index) {
                      final book = filteredBooks[index];
                      return BookCard(
                        book: book,
                        onTap: () => context.push('/community/${book.id}'),
                      );
                    },
                  ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Книги сообщества')),
      body: body,
    );
  }
}
