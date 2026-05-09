import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final colors = _colorsForStatus(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: colors.foreground.withValues(alpha: 0.18)),
      ),
      child: Text(
        labelForStatus(status),
        style: TextStyle(
          color: colors.foreground,
          fontSize: 12,
          height: 1,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  static String labelForStatus(String value) {
    switch (value) {
      case 'AGENDADA':
        return 'Agendada';
      case 'EM_ANDAMENTO':
        return 'Em andamento';
      case 'CONCLUIDA':
        return 'Concluída';
      case 'CANCELADA':
        return 'Cancelada';
      default:
        return value;
    }
  }

  _BadgeColors _colorsForStatus(String value) {
    switch (value) {
      case 'AGENDADA':
        return const _BadgeColors(AppColors.scheduled, AppColors.scheduledText);
      case 'EM_ANDAMENTO':
        return const _BadgeColors(
          AppColors.inProgress,
          AppColors.inProgressText,
        );
      case 'CONCLUIDA':
        return const _BadgeColors(AppColors.completed, AppColors.completedText);
      case 'CANCELADA':
        return const _BadgeColors(AppColors.canceled, AppColors.canceledText);
      default:
        return const _BadgeColors(AppColors.border, AppColors.textSecondary);
    }
  }
}

class _BadgeColors {
  const _BadgeColors(this.background, this.foreground);

  final Color background;
  final Color foreground;
}
