import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_empty_state.dart';
import '../../state/auth_state.dart';

class ViagensListPage extends StatelessWidget {
  const ViagensListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Viagens'),
        actions: [
          IconButton(
            tooltip: 'Sair',
            onPressed: authState.isLoading
                ? null
                : () => context.read<AuthState>().logout(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const AppEmptyState(
        title: 'Viagens',
        message: 'A lista de viagens sera implementada na proxima etapa.',
        icon: Icons.route_outlined,
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: AppButton(
          label: authState.isLoading ? 'Saindo...' : 'Sessao autenticada',
          icon: Icons.verified_user_outlined,
          onPressed: null,
        ),
      ),
      backgroundColor: AppColors.background,
    );
  }
}
