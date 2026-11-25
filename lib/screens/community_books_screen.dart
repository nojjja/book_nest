import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/book.dart';
import '../data/loan_actions.dart';
import '../models/books_model.dart';
import '../theme/app_theme.dart';
import '../widgets/book_shelf_row.dart';
import '../widgets/error_view.dart';
import '../widgets/genre_filter_tabs.dart';

class CommunityBooksScreen extends StatefulWidget {
  const CommunityBooksScreen({super.key});

  @override
  State<CommunityBooksScreen> createState() => _CommunityBooksScreenState();
}

class _CommunityBooksScreenState extends State<CommunityBooksScreen> {
  String _selectedGenre = 'Все';
  String _searchQuery = '';

  Future<void> _request(Book book) async {
    final error = await requestBookLoan(context, book);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          error ?? 'Запрос отправлен. Книга добавлена в ваши обмены.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<BooksModel>();
    final communityBooks = model.books
        .where((book) => book.ownerId != 'user1')
        .toList();
    final genres = <String>[
      'Все',
      ...communityBooks.map((book) => book.genre).toSet(),
    ];
    final counts = <String, int>{
      for (final genre in genres)
        genre: genre == 'Все'
            ? communityBooks.length
            : communityBooks.where((book) => book.genre == genre).length,
    };
    final query = _searchQuery.trim().toLowerCase();
    final visibleBooks = communityBooks.where((book) {
      final matchesGenre =
          _selectedGenre == 'Все' || book.genre == _selectedGenre;
      final matchesQuery =
          book.title.toLowerCase().contains(query) ||
          book.author.toLowerCase().contains(query);
      return matchesGenre && matchesQuery;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Сообщество')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ОТКРЫТЫЙ КАТАЛОГ  /  02',
                  style: AppTheme.mono(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.charcoalMuted,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Книги сообщества',
                  style: AppTheme.serifHeading(fontSize: 28),
                ),
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
                      'Совпадений в каталоге нет',
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
                        onTap: () => context.push('/community/${book.id}'),
                        trailing: book.status == BookStatus.available
                            ? Align(
                                alignment: Alignment.centerLeft,
                                child: OutlinedButton(
                                  onPressed: () => _request(book),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppTheme.forestEmerald,
                                    side: const BorderSide(
                                      color: AppTheme.forestEmerald,
                                      width: .8,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 7,
                                    ),
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero,
                                    ),
                                  ),
                                  child: Text(
                                    'ЗАПРОСИТЬ КНИГУ',
                                    style: AppTheme.mono(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.forestEmerald,
                                    ),
                                  ),
                                ),
                              )
                            : null,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
