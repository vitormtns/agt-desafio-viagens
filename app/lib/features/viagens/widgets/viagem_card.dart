import 'package:flutter/material.dart';

import '../../../models/viagem.dart';

class ViagemCard extends StatelessWidget {
  const ViagemCard({super.key, required this.viagem, this.onTap});

  final Viagem viagem;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(viagem.destino),
        subtitle: Text(viagem.finalidade),
      ),
    );
  }
}
