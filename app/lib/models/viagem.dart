class Viagem {
  const Viagem({
    required this.id,
    required this.destino,
    required this.dataIda,
    required this.dataVolta,
    required this.finalidade,
    required this.transporte,
    this.observacoes,
    required this.status,
    required this.criadoEm,
  });

  final int id;
  final String destino;
  final DateTime dataIda;
  final DateTime dataVolta;
  final String finalidade;
  final String transporte;
  final String? observacoes;
  final String status;
  final DateTime criadoEm;

  factory Viagem.fromJson(Map<String, dynamic> json) {
    return Viagem(
      id: json['id'] as int,
      destino: json['destino'] as String,
      dataIda: DateTime.parse(json['dataIda'] as String),
      dataVolta: DateTime.parse(json['dataVolta'] as String),
      finalidade: json['finalidade'] as String,
      transporte: json['transporte'] as String,
      observacoes: json['observacoes'] as String?,
      status: json['status'] as String,
      criadoEm: DateTime.parse(json['criadoEm'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'destino': destino,
      'dataIda': dataIda.toIso8601String(),
      'dataVolta': dataVolta.toIso8601String(),
      'finalidade': finalidade,
      'transporte': transporte,
      'observacoes': observacoes,
      'status': status,
      'criadoEm': criadoEm.toIso8601String(),
    };
  }
}
