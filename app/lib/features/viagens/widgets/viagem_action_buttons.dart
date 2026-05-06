import 'package:flutter/material.dart';

import '../../../core/widgets/app_button.dart';

class ViagemActionButtons extends StatelessWidget {
  const ViagemActionButtons({super.key, this.onEdit, this.onCancel});

  final VoidCallback? onEdit;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            label: 'Editar',
            icon: Icons.edit_outlined,
            onPressed: onEdit,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onCancel,
            icon: const Icon(Icons.cancel_outlined),
            label: const Text('Cancelar'),
          ),
        ),
      ],
    );
  }
}
