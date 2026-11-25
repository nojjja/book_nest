import 'package:flutter/material.dart';

import '../data/book.dart';
import '../theme/app_theme.dart';
import 'book_cover.dart';

/// An editorial shelf row: cover on a ruled baseline, with no card surface.
class BookShelfRow extends StatelessWidget {
  const BookShelfRow({
    super.key,
    required this.book,
    required this.onTap,
    this.trailing,
  });

  final Book book;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final isAvailable = book.status == BookStatus.available;
    final statusColor = isAvailable
        ? AppTheme.forestEmerald
        : AppTheme.waxTerracotta;

    return InkWell(
      onTap: onTap,
      splashColor: AppTheme.hairline,
      highlightColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.fromLTRB(18, 13, 18, 12),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppTheme.hairline, width: 1),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BookCover(book: book, width: 58, height: 84),
            const SizedBox(width: 15),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 7,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          book.genre.toUpperCase(),
                          style: AppTheme.mono(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.charcoalMuted,
                            letterSpacing: .8,
                          ),
                        ),
                        Text('·', style: TextStyle(color: statusColor)),
                        Text(
                          book.status.bookStatusLabel.toUpperCase(),
                          style: AppTheme.mono(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: statusColor,
                            letterSpacing: .6,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.serifHeading(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        height: 1.17,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTheme.sans(
                        fontSize: 12.5,
                        color: AppTheme.charcoalMuted,
                      ),
                    ),
                    if (trailing != null) ...[
                      const SizedBox(height: 8),
                      trailing!,
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
