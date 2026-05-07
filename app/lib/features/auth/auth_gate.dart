import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/app_loading.dart';
import '../../state/auth_state.dart';
import '../viagens/viagens_list_page.dart';
import 'login_page.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AuthState>().checkAuthStatus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthState>();

    if (authState.isCheckingAuth) {
      return const Scaffold(body: AppLoading(message: 'Verificando sessao...'));
    }

    if (authState.isAuthenticated) {
      return const ViagensListPage();
    }

    return const LoginPage();
  }
}
