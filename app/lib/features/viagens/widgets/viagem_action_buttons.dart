import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../status_action_rules.dart';

class ViagemActionButtons extends StatelessWidget {
  const ViagemActionButtons({
    super.key,
    required this.status,
    required this.isLoading,
    required this.onChangeStatus,
  });

  final String status;
  final bool isLoading;
  final ValueChanged<String> onChangeStatus;

  @override
  Widget build(BuildContext context) {
    final actions = statusActionsFor(status);

    if (actions.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (index, action) in actions.indexed) ...[
            if (index > 0) const SizedBox(height: 12),
            _ActionButton(
              action: action,
              isLoading: isLoading,
              onPressed: () => onChangeStatus(action.nextStatus),
            ),
          ],
        ],
      );
    }

    return const SizedBox.shrink();
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.action,
    required this.isLoading,
    required this.onPressed,
  });

  final StatusAction action;
  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (action.nextStatus != 'CANCELADA') {
      return AppButton(
        label: action.label,
        icon: action.nextStatus == 'EM_ANDAMENTO'
            ? Icons.play_arrow_outlined
            : Icons.check_circle_outline,
        isLoading: isLoading,
        onPressed: onPressed,
      );
    }

    return OutlinedButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: const Icon(Icons.cancel_outlined),
      label: Text(action.label),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.canceledText,
        side: BorderSide(color: AppColors.canceledText.withValues(alpha: 0.8)),
        minimumSize: const Size.fromHeight(52),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
