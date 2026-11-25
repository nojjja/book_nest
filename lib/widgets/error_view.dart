import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Виджет ошибки в букинистическом стиле (с сообщением и retry)
class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            border: Border.all(color: AppTheme.waxTerracotta.withValues(alpha: 0.4), width: 1.0),
            color: AppTheme.paperDarker.withValues(alpha: 0.4),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '• АРХИВНЫЙ СБОЙ •',
                style: AppTheme.mono(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.waxTerracotta,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: AppTheme.serifHeading(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.charcoal,
                ),
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: onRetry,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.charcoal,
                  side: const BorderSide(color: AppTheme.charcoal, width: 1.2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                icon: const Icon(Icons.refresh, size: 16),
                label: Text(
                  'ПОВТОРИТЬ ЗАПРОС',
                  style: AppTheme.mono(fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
