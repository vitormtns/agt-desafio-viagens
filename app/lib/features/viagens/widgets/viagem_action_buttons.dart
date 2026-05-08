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

    if (status == 'CONCLUIDA') {
      return const _StatusMessage(
        icon: Icons.check_circle_outline,
        message: 'Esta viagem já foi concluída.',
      );
    }

    if (status == 'CANCELADA') {
      return const _StatusMessage(
        icon: Icons.cancel_outlined,
        message: 'Esta viagem foi cancelada.',
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
        side: const BorderSide(color: AppColors.canceledText),
        minimumSize: const Size.fromHeight(48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}

class _StatusMessage extends StatelessWidget {
  const _StatusMessage({required this.icon, required this.message});

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
