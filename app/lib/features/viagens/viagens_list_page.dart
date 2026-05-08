import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_empty_state.dart';
import '../../core/widgets/app_error_state.dart';
import '../../core/widgets/app_loading.dart';
import '../../services/api_client.dart';
import '../../state/auth_state.dart';
import '../../state/viagem_state.dart';
import 'viagem_detail_page.dart';
import 'viagem_form_page.dart';
import 'widgets/viagem_card.dart';

class ViagensListPage extends StatefulWidget {
  const ViagensListPage({super.key});

  @override
  State<ViagensListPage> createState() => _ViagensListPageState();
}

class _ViagensListPageState extends State<ViagensListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadViagens();
      }
    });
  }

  Future<void> _loadViagens() async {
    try {
      await context.read<ViagemState>().loadViagens();
    } on ApiUnauthorizedException {
      if (mounted) {
        await context.read<AuthState>().expireSession();
      }
    }
  }

  Future<void> _openNewViagem() async {
    final created = await Navigator.of(
      context,
    ).push<bool>(MaterialPageRoute(builder: (_) => const ViagemFormPage()));

    if (!mounted || created != true) {
      return;
    }

    await _loadViagens();
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthState>();
    final viagemState = context.watch<ViagemState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas viagens'),
        actions: [
          IconButton(
            tooltip: 'Atualizar viagens',
            onPressed: viagemState.isLoading ? null : _loadViagens,
            icon: viagemState.isLoading
                ? const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: 'Sair',
            onPressed: authState.isLoading
                ? null
                : () => context.read<AuthState>().logout(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadViagens,
        child: _ViagensBody(
          viagemState: viagemState,
          onRetry: _loadViagens,
          onNewViagem: _openNewViagem,
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openNewViagem,
        icon: const Icon(Icons.add),
        label: const Text('Nova viagem'),
      ),
      backgroundColor: AppColors.background,
    );
  }
}

class _ViagensBody extends StatelessWidget {
  const _ViagensBody({
    required this.viagemState,
    required this.onRetry,
    required this.onNewViagem,
  });

  final ViagemState viagemState;
  final Future<void> Function() onRetry;
  final VoidCallback onNewViagem;

  @override
  Widget build(BuildContext context) {
    if (viagemState.isLoading) {
      return const AppLoading(message: 'Carregando viagens...');
    }

    if (viagemState.errorMessage != null) {
      return AppErrorState(
        message: viagemState.errorMessage!,
        onRetry: onRetry,
      );
    }

    if (viagemState.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 128),
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.55,
            child: AppEmptyState(
              title: 'Nenhuma viagem cadastrada',
              message: 'Crie sua primeira solicitação de viagem corporativa.',
              icon: Icons.route_outlined,
              actionLabel: 'Nova viagem',
              actionIcon: Icons.add,
              onAction: onNewViagem,
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 128),
      itemCount: viagemState.viagens.length + 1,
      separatorBuilder: (_, index) =>
          index == 0 ? const SizedBox(height: 16) : const SizedBox(height: 12),
      itemBuilder: (context, index) {
        if (index == 0) {
          return const _ListHeader();
        }

        final viagem = viagemState.viagens[index - 1];
        return ViagemCard(
          viagem: viagem,
          onTap: () async {
            final changed = await Navigator.of(context).push<bool>(
              MaterialPageRoute(
                builder: (_) => ViagemDetailPage(viagem: viagem),
              ),
            );

            if (!context.mounted || changed != true) {
              return;
            }

            await onRetry();
          },
        );
      },
    );
  }
}

class _ListHeader extends StatelessWidget {
  const _ListHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Acompanhe suas solicitações corporativas',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 4),
        Text(
          'Consulte destino, período, transporte e status das viagens.',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
