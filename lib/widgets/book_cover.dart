import 'package:flutter/material.dart';

import '../data/book.dart';
import '../theme/app_theme.dart';

/// Archive-inspired cover artwork for books without a remote image.
class BookCover extends StatelessWidget {
  const BookCover({
    super.key,
    required this.book,
    this.width = 220,
    this.height = 310,
  });

  final Book book;
  final double width;
  final double height;

  static const _paperColors = [
    Color(0xFFE9DDC9),
    Color(0xFFD9E0D5),
    Color(0xFFE9D4C9),
    Color(0xFFD9D5C8),
  ];

  @override
  Widget build(BuildContext context) {
    final index = int.tryParse(book.id) ?? 0;
    final paper = _paperColors[index % _paperColors.length];
    final cover = book.coverUrl.trim();

    return Hero(
      tag: 'book_cover_${book.id}',
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(width < 90 ? 5 : 12),
        decoration: BoxDecoration(
          color: paper,
          border: Border.all(color: AppTheme.charcoal.withValues(alpha: .42)),
        ),
        child: cover.isNotEmpty
            ? Image.network(
                cover,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _CoverArtwork(book: book, compact: width < 90),
              )
            : _CoverArtwork(book: book, compact: width < 90),
      ),
    );
  }
}

class _CoverArtwork extends StatelessWidget {
  const _CoverArtwork({required this.book, required this.compact});

  final Book book;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.charcoal.withValues(alpha: .2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (!compact)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'BOOKNEST',
                  style: AppTheme.mono(fontSize: 7, letterSpacing: 1),
                ),
                Text('№ ${book.id}', style: AppTheme.mono(fontSize: 7)),
              ],
            ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.menu_book_rounded,
                    size: compact ? 18 : 44,
                    color: AppTheme.forestEmerald,
                  ),
                  if (!compact) ...[
                    const SizedBox(height: 12),
                    Text(
                      book.title.toUpperCase(),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: AppTheme.serifHeading(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      book.author.toUpperCase(),
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: AppTheme.mono(
                        fontSize: 7,
                        color: AppTheme.charcoalMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (!compact)
            Container(
              height: 2,
              color: AppTheme.forestEmerald.withValues(alpha: .7),
            ),
        ],
      ),
    );
  }
}
