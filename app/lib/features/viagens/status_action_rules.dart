class StatusAction {
  const StatusAction({required this.label, required this.nextStatus});

  final String label;
  final String nextStatus;
}

const iniciarViagemAction = StatusAction(
  label: 'Iniciar viagem',
  nextStatus: 'EM_ANDAMENTO',
);

const concluirViagemAction = StatusAction(
  label: 'Concluir viagem',
  nextStatus: 'CONCLUIDA',
);

const cancelarViagemAction = StatusAction(
  label: 'Cancelar viagem',
  nextStatus: 'CANCELADA',
);

List<StatusAction> statusActionsFor(String status) {
  switch (status) {
    case 'AGENDADA':
      return const [iniciarViagemAction, cancelarViagemAction];
    case 'EM_ANDAMENTO':
      return const [concluirViagemAction, cancelarViagemAction];
    case 'CONCLUIDA':
    case 'CANCELADA':
      return const [];
    default:
      return const [];
  }
}
