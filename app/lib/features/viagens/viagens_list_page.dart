import 'package:flutter/material.dart';

import '../../core/widgets/app_empty_state.dart';

class ViagensListPage extends StatelessWidget {
  const ViagensListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AppEmptyState(
        title: 'Lista de viagens sera implementada na proxima etapa',
        icon: Icons.route_outlined,
      ),
    );
  }
}
