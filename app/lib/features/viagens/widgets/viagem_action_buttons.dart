import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_button.dart';

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
    switch (status) {
      case 'AGENDADA':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppButton(
              label: 'Iniciar viagem',
              icon: Icons.play_arrow_outlined,
              isLoading: isLoading,
              onPressed: () => onChangeStatus('EM_ANDAMENTO'),
            ),
            const SizedBox(height: 12),
            _CancelButton(
              isLoading: isLoading,
              onPressed: () => onChangeStatus('CANCELADA'),
            ),
          ],
        );
      case 'EM_ANDAMENTO':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppButton(
              label: 'Concluir viagem',
              icon: Icons.check_circle_outline,
              isLoading: isLoading,
              onPressed: () => onChangeStatus('CONCLUIDA'),
            ),
            const SizedBox(height: 12),
            _CancelButton(
              isLoading: isLoading,
              onPressed: () => onChangeStatus('CANCELADA'),
            ),
          ],
        );
      case 'CONCLUIDA':
        return const _StatusMessage(
          icon: Icons.check_circle_outline,
          message: 'Esta viagem já foi concluída.',
        );
      case 'CANCELADA':
        return const _StatusMessage(
          icon: Icons.cancel_outlined,
          message: 'Esta viagem foi cancelada.',
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class _CancelButton extends StatelessWidget {
  const _CancelButton({required this.isLoading, required this.onPressed});

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: const Icon(Icons.cancel_outlined),
      label: const Text('Cancelar viagem'),
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
