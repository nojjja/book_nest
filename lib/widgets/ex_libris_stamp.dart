import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../data/book.dart';
import '../theme/app_theme.dart';

/// Виджет «Штамп экслибриса» (Ex-Libris Stamp)
/// Повернут на -4°, имитирует чернильный оттиск на старинной бумаге
/// с двойной рамкой и пружинной анимацией появления.
class ExLibrisStamp extends StatefulWidget {
  final BookStatus status;
  final String? dueDate;
  final String inventoryId;

  const ExLibrisStamp({
    super.key,
    required this.status,
    this.dueDate,
    required this.inventoryId,
  });

  @override
  State<ExLibrisStamp> createState() => _ExLibrisStampState();
}

class _ExLibrisStampState extends State<ExLibrisStamp>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    // Пружинная анимация появления (штамп с силой опускается на страницу)
    _scaleAnimation = Tween<double>(
      begin: 1.4,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _rotationAnimation = Tween<double>(
      begin: 0.05,
      end: -4 * math.pi / 180,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAvailable = widget.status == BookStatus.available;
    final stampColor = isAvailable
        ? AppTheme.forestEmerald
        : AppTheme.waxTerracotta;

    final String statusText;
    if (isAvailable) {
      statusText = 'ДОСТУПНА В ЧИТАЛЬНЕ';
    } else if (widget.dueDate != null && widget.dueDate!.isNotEmpty) {
      statusText = 'ВЫДАНА ДО ${widget.dueDate}';
    } else {
      statusText = 'ВЫДАНА ИЗ АРХИВА';
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value,
          child: Transform.scale(scale: _scaleAnimation.value, child: child),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: stampColor.withValues(alpha: 0.85),
            width: 2.2,
          ),
          borderRadius: BorderRadius.circular(4),
          color: AppTheme.paper.withValues(alpha: 0.6),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color: stampColor.withValues(alpha: 0.5),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '• EX LIBRIS BOOKNEST •',
                style: AppTheme.mono(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w600,
                  color: stampColor.withValues(alpha: 0.75),
                  letterSpacing: 1.8,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                statusText,
                textAlign: TextAlign.center,
                style: AppTheme.mono(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: stampColor,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'ИНВ. № BK-${widget.inventoryId.padLeft(4, '0')}',
                style: AppTheme.mono(
                  fontSize: 8.5,
                  color: stampColor.withValues(alpha: 0.65),
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
