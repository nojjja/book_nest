import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Визуальная система «Букинистический архив» (Editorial Library & Ex-Libris)
class AppTheme {
  AppTheme._();

  // ─── Палитра ──────────────────────────────────────────────────────────────
  /// Фон экранов: тёплый оттенок неотбеленной бумаги
  static const Color paper = Color(0xFFF7F4EE);

  /// Поверхность полок и подложка обложек
  static const Color paperDarker = Color(0xFFECE7DE);
  static const Color paperCard = Color(0xFFF2EEE6);

  /// Основной текст и контуры: глубокий угольный
  static const Color charcoal = Color(0xFF1D1B18);
  static const Color charcoalMuted = Color(0x991D1B18);
  static const Color charcoalLight = Color(0x591D1B18);

  /// Тонкие разделители сетки (1px hairline, 15% прозрачности)
  static const Color hairline = Color(0x261D1B18);

  /// Акцент: изумрудно-лесной (статус «Доступна», ключевые действия)
  static const Color forestEmerald = Color(0xFF2D5A4C);
  static const Color forestEmeraldSoft = Color(0x1F2D5A4C);

  /// Акцент: сургучно-терракотовый (статус «Выдана», ошибки, дедлайн)
  static const Color waxTerracotta = Color(0xFFC84B31);
  static const Color waxTerracottaSoft = Color(0x1FC84B31);

  // ─── Типографика ──────────────────────────────────────────────────────────
  /// Контрастная антиква для заголовков и названий книг
  static TextStyle serifHeading({
    double fontSize = 22,
    FontWeight fontWeight = FontWeight.w600,
    Color color = charcoal,
    double letterSpacing = -0.5,
    double? height,
  }) {
    return GoogleFonts.lora(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  /// Гротеск для общего интерфейса, кнопок и авторов
  static TextStyle sans({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.normal,
    Color color = charcoal,
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  /// Моноширинный шрифт для дат, кодов инвентаря и жанровых плашек
  static TextStyle mono({
    double fontSize = 11,
    FontWeight fontWeight = FontWeight.w500,
    Color color = charcoal,
    double letterSpacing = 0.8,
  }) {
    return GoogleFonts.jetBrainsMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
    );
  }

  // ─── Полная тема Material 3 ──────────────────────────────────────────────
  static ThemeData get themeData {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: forestEmerald,
          brightness: Brightness.light,
          surface: paper,
          error: waxTerracotta,
        ).copyWith(
          primary: forestEmerald,
          onPrimary: paper,
          primaryContainer: forestEmeraldSoft,
          onPrimaryContainer: forestEmerald,
          secondary: charcoal,
          onSecondary: paper,
          secondaryContainer: paperDarker,
          onSecondaryContainer: charcoal,
          error: waxTerracotta,
          onError: Colors.white,
          errorContainer: waxTerracottaSoft,
          onErrorContainer: waxTerracotta,
          surface: paper,
          onSurface: charcoal,
          surfaceContainerHighest: paperCard,
          outline: hairline,
          outlineVariant: hairline,
        );
    final textTheme = TextTheme(
      headlineLarge: serifHeading(fontSize: 30, fontWeight: FontWeight.bold),
      headlineMedium: serifHeading(fontSize: 24, fontWeight: FontWeight.w700),
      headlineSmall: serifHeading(fontSize: 20, fontWeight: FontWeight.w600),
      titleLarge: serifHeading(fontSize: 18, fontWeight: FontWeight.w600),
      titleMedium: sans(fontSize: 15, fontWeight: FontWeight.w600),
      titleSmall: sans(fontSize: 13, fontWeight: FontWeight.w500),
      bodyLarge: sans(fontSize: 15, height: 1.45),
      bodyMedium: sans(fontSize: 13.5, height: 1.4),
      bodySmall: sans(fontSize: 12, color: charcoalMuted),
      labelLarge: mono(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.0,
      ),
      labelMedium: mono(fontSize: 10.5, letterSpacing: 0.8),
      labelSmall: mono(fontSize: 9.5, letterSpacing: 0.5),
    );

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: paper,
      colorScheme: colorScheme,
      textTheme: textTheme,
      dividerColor: hairline,
      dividerTheme: const DividerThemeData(
        color: hairline,
        thickness: 1,
        space: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: paper,
        foregroundColor: charcoal,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: serifHeading(fontSize: 20, fontWeight: FontWeight.w700),
        iconTheme: const IconThemeData(color: charcoal),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: paper,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        indicatorColor: Colors.transparent, // Отключение овальных "пузырей"
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return mono(
            fontSize: 10,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? forestEmerald : charcoalMuted,
            letterSpacing: 0.6,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final isSelected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: isSelected ? forestEmerald : charcoalMuted,
            size: 22,
          );
        }),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: hairline, width: 1),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: hairline, width: 1),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: charcoal, width: 2),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: waxTerracotta, width: 1.5),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: waxTerracotta, width: 2),
        ),
        labelStyle: mono(fontSize: 12, color: charcoalMuted),
        hintStyle: sans(fontSize: 14, color: charcoalLight),
      ),
    );
  }
}
