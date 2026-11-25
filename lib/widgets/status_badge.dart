import 'package:flutter/material.dart';

import '../data/book.dart';
import '../theme/app_theme.dart';

class StatusBadge extends StatelessWidget {
  final BookStatus status;

  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final isAvailable = status == BookStatus.available;
    final color = isAvailable ? AppTheme.forestEmerald : AppTheme.waxTerracotta;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 1.0),
        borderRadius: BorderRadius.circular(2),
        color: color.withValues(alpha: 0.08),
      ),
      child: Text(
        status.bookStatusLabel.toUpperCase(),
        style: AppTheme.mono(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
