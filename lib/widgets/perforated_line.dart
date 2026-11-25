import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Перфорированная пунктирная линия отрыва архивного формуляра
class PerforatedLine extends StatelessWidget {
  final double height;
  final Color color;
  final double dashWidth;
  final double dashSpace;

  const PerforatedLine({
    super.key,
    this.height = 1,
    this.color = AppTheme.hairline,
    this.dashWidth = 5.0,
    this.dashSpace = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashCount = (boxWidth / (dashWidth + dashSpace)).floor();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: height,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}
