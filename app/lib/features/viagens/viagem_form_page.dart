import 'package:flutter/material.dart';

import '../../core/widgets/app_empty_state.dart';

class ViagemFormPage extends StatelessWidget {
  const ViagemFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AppEmptyState(
        title: 'Formulário de viagem será implementado na próxima etapa',
        icon: Icons.edit_note_outlined,
      ),
    );
  }
}
