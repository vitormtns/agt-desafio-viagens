import 'package:flutter/material.dart';

import '../../core/widgets/app_empty_state.dart';

class ViagemFormPage extends StatelessWidget {
  const ViagemFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AppEmptyState(
        title: 'Formulario de viagem sera implementado na proxima etapa',
        icon: Icons.edit_note_outlined,
      ),
    );
  }
}
