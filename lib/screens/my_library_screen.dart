import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/books_model.dart';
import '../theme/app_theme.dart';
import '../widgets/book_shelf_row.dart';
import '../widgets/error_view.dart';
import '../widgets/genre_filter_tabs.dart';

class MyLibraryScreen extends StatefulWidget {
  const MyLibraryScreen({super.key});

  @override
  State<MyLibraryScreen> createState() => _MyLibraryScreenState();
}

class _MyLibraryScreenState extends State<MyLibraryScreen> {
  String _selectedGenre = 'Все';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final model = context.watch<BooksModel>();
    final books = model.myBooks;
    final genres = <String>['Все', ...books.map((book) => book.genre).toSet()];
    final counts = <String, int>{
      for (final genre in genres)
        genre: genre == 'Все'
            ? books.length
            : books.where((book) => book.genre == genre).length,
    };
    final visibleBooks = books.where((book) {
      final matchesGenre =
          _selectedGenre == 'Все' || book.genre == _selectedGenre;
      final query = _searchQuery.trim().toLowerCase();
      final matchesQuery =
          book.title.toLowerCase().contains(query) ||
          book.author.toLowerCase().contains(query);
      return matchesGenre && matchesQuery;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('BookNest'),
        actions: [
          TextButton.icon(
            onPressed: () => context.push('/library/add'),
            icon: const Icon(Icons.add, size: 17),
            label: Text(
              'В АРХИВ',
              style: AppTheme.mono(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: AppTheme.forestEmerald,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ЛИЧНЫЙ ФОНД  /  01',
                  style: AppTheme.mono(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.charcoalMuted,
                  ),
                ),
                const SizedBox(height: 3),
                Text('Моя полка', style: AppTheme.serifHeading(fontSize: 30)),
                const SizedBox(height: 8),
                TextField(
                  onChanged: (value) => setState(() => _searchQuery = value),
                  style: AppTheme.sans(fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: 'Поиск по названию или автору',
                    prefixIcon: Icon(Icons.search, size: 19),
                    isDense: true,
                  ),
                ),
              ],
            ),
          ),
          GenreFilterTabs(
            genres: genres,
            selectedGenre: _selectedGenre,
            counts: counts,
            onGenreSelected: (genre) => setState(() => _selectedGenre = genre),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: model.isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.forestEmerald,
                      strokeWidth: 1.5,
                    ),
                  )
                : model.error != null
                ? ErrorView(
                    message: model.error!,
                    onRetry: () => context.read<BooksModel>().load(),
                  )
                : visibleBooks.isEmpty
                ? Center(
                    child: Text(
                      'В этом разделе пока пусто',
                      style: AppTheme.serifHeading(
                        fontSize: 18,
                        color: AppTheme.charcoalMuted,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: visibleBooks.length,
                    itemBuilder: (context, index) {
                      final book = visibleBooks[index];
                      return BookShelfRow(
                        key: ValueKey(book.id),
                        book: book,
                        onTap: () => context.push('/library/${book.id}'),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
