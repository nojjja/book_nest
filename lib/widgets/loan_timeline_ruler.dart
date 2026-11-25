import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Визуальная линейка-таймлайн от startDate до dueDate.
/// Меняет цвет на сургучно-терракотовый при приближении срока сдачи.
class LoanTimelineRuler extends StatelessWidget {
  final String startDate;
  final String dueDate;

  const LoanTimelineRuler({
    super.key,
    required this.startDate,
    required this.dueDate,
  });

  // Парсинг дат вида "ДД.ММ.ГГГГ" для вычисления прогресса
  double _calculateProgress() {
    try {
      final startParts = startDate.split('.').map(int.parse).toList();
      final dueParts = dueDate.split('.').map(int.parse).toList();

      final start = DateTime(startParts[2], startParts[1], startParts[0]);
      final due = DateTime(dueParts[2], dueParts[1], dueParts[0]);
      final now = DateTime.now();

      final total = due.difference(start).inDays;
      if (total <= 0) return 1.0;

      final elapsed = now.difference(start).inDays;
      return (elapsed / total).clamp(0.08, 1.0);
    } catch (_) {
      return 0.65;
    }
  }

  bool _isNearDeadline() {
    try {
      final dueParts = dueDate.split('.').map(int.parse).toList();
      final due = DateTime(dueParts[2], dueParts[1], dueParts[0]);
      final remaining = due.difference(DateTime.now()).inDays;
      return remaining <= 5;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = _calculateProgress();
    final isUrgent = _isNearDeadline();
    final accentColor = isUrgent ? AppTheme.waxTerracotta : AppTheme.forestEmerald;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today_outlined, size: 11, color: AppTheme.charcoalMuted),
                const SizedBox(width: 4),
                Text(
                  'ВЗЯТА: $startDate',
                  style: AppTheme.mono(fontSize: 10, color: AppTheme.charcoalMuted),
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.timelapse,
                  size: 11,
                  color: isUrgent ? AppTheme.waxTerracotta : AppTheme.charcoalMuted,
                ),
                const SizedBox(width: 4),
                Text(
                  'СРОК: $dueDate',
                  style: AppTheme.mono(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: isUrgent ? AppTheme.waxTerracotta : AppTheme.charcoal,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 7),

        // Линейка с делениями (Tactile Archival Ruler)
        Stack(
          children: [
            // Фоновая линейка с метками
            Container(
              height: 12,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppTheme.hairline, width: 1.2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(11, (i) {
                  final isMajor = i == 0 || i == 5 || i == 10;
                  return Container(
                    width: 1,
                    height: isMajor ? 10 : 5,
                    color: AppTheme.charcoalLight.withValues(alpha: 0.4),
                  );
                }),
              ),
            ),

            // Заполненная шкала прогресса
            FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                height: 12,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: accentColor, width: 2.2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
