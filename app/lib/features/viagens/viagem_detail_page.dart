import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/status_badge.dart';
import '../../models/viagem.dart';
import '../../services/api_client.dart';
import '../../state/auth_state.dart';
import '../../state/viagem_state.dart';
import 'widgets/viagem_action_buttons.dart';

class ViagemDetailPage extends StatefulWidget {
  const ViagemDetailPage({super.key, required this.viagem});

  final Viagem viagem;

  @override
  State<ViagemDetailPage> createState() => _ViagemDetailPageState();
}

class _ViagemDetailPageState extends State<ViagemDetailPage> {
  late Viagem _viagem;
  bool _hasStatusChanged = false;

  @override
  void initState() {
    super.initState();
    _viagem = widget.viagem;
  }

  Future<void> _handleStatusChange(String status) async {
    final shouldContinue = await _confirmStatusChange(status);
    if (!shouldContinue || !mounted) {
      return;
    }

    final updated = await _atualizarStatus(status);

    if (!mounted) {
      return;
    }

    if (!context.read<AuthState>().isAuthenticated) {
      return;
    }

    if (updated == null) {
      final message =
          context.read<ViagemState>().errorMessage ??
          'Não foi possível atualizar o status.';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
      return;
    }

    setState(() {
      _viagem = updated;
      _hasStatusChanged = true;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(_successMessage(status))));
  }

  Future<Viagem?> _atualizarStatus(String status) async {
    try {
      return await context.read<ViagemState>().atualizarStatusViagem(
        _viagem.id,
        status,
      );
    } on ApiUnauthorizedException {
      if (mounted) {
        await context.read<AuthState>().expireSession();
      }
      return null;
    }
  }

  Future<bool> _confirmStatusChange(String status) async {
    if (status == 'EM_ANDAMENTO') {
      return true;
    }

    final title = status == 'CANCELADA'
        ? 'Cancelar viagem?'
        : 'Concluir viagem?';
    final message = status == 'CANCELADA'
        ? 'Esta ação não poderá ser desfeita.'
        : 'Confirme para marcar esta viagem como concluída.';
    final confirmLabel = status == 'CANCELADA'
        ? 'Cancelar viagem'
        : 'Concluir viagem';

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Voltar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(confirmLabel),
            ),
          ],
        );
      },
    );

    return result ?? false;
  }

  String _successMessage(String status) {
    switch (status) {
      case 'EM_ANDAMENTO':
        return 'Viagem iniciada com sucesso';
      case 'CONCLUIDA':
        return 'Viagem concluída com sucesso';
      case 'CANCELADA':
        return 'Viagem cancelada com sucesso';
      default:
        return 'Status atualizado com sucesso';
    }
  }

  @override
  Widget build(BuildContext context) {
    final viagemState = context.watch<ViagemState>();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          return;
        }
        Navigator.of(context).pop(_hasStatusChanged);
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Detalhe da viagem')),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
            children: [
              _Header(viagem: _viagem),
              const SizedBox(height: 18),
              _InfoCard(viagem: _viagem),
              const SizedBox(height: 18),
              _NextActionCard(status: _viagem.status),
              const SizedBox(height: 22),
              ViagemActionButtons(
                status: _viagem.status,
                isLoading: viagemState.isUpdatingStatus,
                onChangeStatus: _handleStatusChange,
              ),
            ],
          ),
        ),
        backgroundColor: AppColors.background,
      ),
    );
  }
}

class _NextActionCard extends StatelessWidget {
  const _NextActionCard({required this.status});

  final String status;

  String get _message {
    switch (status) {
      case 'AGENDADA':
        return 'Esta viagem está agendada. Você pode iniciar ou cancelar a solicitação.';
      case 'EM_ANDAMENTO':
        return 'Esta viagem está em andamento. Você pode concluir ou cancelar a solicitação.';
      case 'CONCLUIDA':
        return 'Esta viagem já foi concluída.';
      case 'CANCELADA':
        return 'Esta viagem foi cancelada.';
      default:
        return 'Acompanhe o status desta solicitação.';
    }
  }

  IconData get _icon {
    switch (status) {
      case 'AGENDADA':
        return Icons.event_available_outlined;
      case 'EM_ANDAMENTO':
        return Icons.directions_walk_outlined;
      case 'CONCLUIDA':
        return Icons.check_circle_outline;
      case 'CANCELADA':
        return Icons.cancel_outlined;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(_icon, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Próxima ação',
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _message,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.viagem});

  final Viagem viagem;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    viagem.destino,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                StatusBadge(status: viagem.status),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                const Icon(
                  Icons.calendar_month_outlined,
                  color: AppColors.primary,
                  size: 19,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${DateFormatter.date(viagem.dataIda)} a ${DateFormatter.date(viagem.dataVolta)}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.viagem});

  final Viagem viagem;

  @override
  Widget build(BuildContext context) {
    final observacoes = viagem.observacoes?.trim();

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        child: Column(
          children: [
            _InfoRow(
              icon: Icons.calendar_today_outlined,
              label: 'Data de ida',
              value: DateFormatter.date(viagem.dataIda),
            ),
            const Divider(height: 22),
            _InfoRow(
              icon: Icons.event_available_outlined,
              label: 'Data de volta',
              value: DateFormatter.date(viagem.dataVolta),
            ),
            const Divider(height: 22),
            _InfoRow(
              icon: Icons.flag_outlined,
              label: 'Finalidade',
              value: viagem.finalidade,
            ),
            const Divider(height: 22),
            _InfoRow(
              icon: Icons.directions_car_outlined,
              label: 'Transporte',
              value: viagem.transporte,
            ),
            const Divider(height: 22),
            _InfoRow(
              icon: Icons.notes_outlined,
              label: 'Observações',
              value: observacoes == null || observacoes.isEmpty
                  ? 'Nenhuma observação informada.'
                  : observacoes,
            ),
            const Divider(height: 22),
            _InfoRow(
              icon: Icons.access_time_outlined,
              label: 'Criada em',
              value: DateFormatter.dateTime(viagem.criadoEm),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: AppColors.primarySoft,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 19),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
