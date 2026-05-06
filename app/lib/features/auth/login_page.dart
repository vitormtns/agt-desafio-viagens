import 'package:flutter/material.dart';

import '../../core/widgets/app_empty_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: AppEmptyState(
        title: 'Login sera implementado na proxima etapa',
        icon: Icons.lock_outline,
      ),
    );
  }
}
