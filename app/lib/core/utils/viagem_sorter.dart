import '../../models/viagem.dart';

List<Viagem> sortViagensForDisplay(Iterable<Viagem> viagens) {
  return [...viagens]..sort((a, b) {
    final statusComparison = _statusPriority(
      a.status,
    ).compareTo(_statusPriority(b.status));

    if (statusComparison != 0) {
      return statusComparison;
    }

    return b.criadoEm.compareTo(a.criadoEm);
  });
}

int _statusPriority(String status) {
  switch (status) {
    case 'EM_ANDAMENTO':
      return 0;
    case 'AGENDADA':
      return 1;
    case 'CONCLUIDA':
      return 2;
    case 'CANCELADA':
      return 3;
    default:
      return 4;
  }
}
