import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Фильтр по жанрам в стиле журнальной строки с надстрочными счётчиками:
/// «ВСЕ ¹²», «ПРОГРАММИРОВАНИЕ ⁴», «ФАНТАСТИКА ²»
class GenreFilterTabs extends StatelessWidget {
  final List<String> genres;
  final String selectedGenre;
  final ValueChanged<String> onGenreSelected;
  final Map<String, int> counts;

  const GenreFilterTabs({
    super.key,
    required this.genres,
    required this.selectedGenre,
    required this.onGenreSelected,
    required this.counts,
  });

  static String toSuperscript(int number) {
    const map = {
      '0': '⁰',
      '1': '¹',
      '2': '²',
      '3': '³',
      '4': '⁴',
      '5': '⁵',
      '6': '⁶',
      '7': '⁷',
      '8': '⁸',
      '9': '⁹',
    };
    return number.toString().split('').map((ch) => map[ch] ?? ch).join();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: genres.map((genre) {
          final isSelected = genre == selectedGenre;
          final count = counts[genre] ?? 0;
          final superCount = toSuperscript(count);

          return GestureDetector(
            onTap: () => onGenreSelected(genre),
            behavior: HitTestBehavior.opaque,
            child: Container(
              margin: const EdgeInsets.only(right: 20),
              padding: const EdgeInsets.only(bottom: 6),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected ? AppTheme.charcoal : Colors.transparent,
                    width: 2.0,
                  ),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    genre.toUpperCase(),
                    style: AppTheme.mono(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected ? AppTheme.charcoal : AppTheme.charcoalMuted,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    superCount,
                    style: AppTheme.mono(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? AppTheme.forestEmerald : AppTheme.charcoalLight,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
