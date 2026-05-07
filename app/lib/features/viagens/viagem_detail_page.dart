import 'package:flutter/material.dart';

import '../../core/widgets/app_empty_state.dart';

class ViagemDetailPage extends StatelessWidget {
  const ViagemDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AppEmptyState(
        title: 'Detalhe da viagem será implementado na próxima etapa',
        icon: Icons.description_outlined,
      ),
    );
  }
}
