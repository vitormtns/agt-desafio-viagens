import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/app_button.dart';
import '../../state/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    await context.read<AuthState>().login(
      _usernameController.text.trim(),
      _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthState>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const Positioned.fill(
            child: CustomPaint(painter: _LoginBackground()),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const _LoginBrandMark(),
                        const SizedBox(height: 22),
                        Text(
                          'AGT Viagens',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                color: AppColors.primaryDark,
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.4,
                                height: 1.08,
                              ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Acesse o controle interno de viagens corporativas.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w400,
                                height: 1.5,
                              ),
                        ),
                        const SizedBox(height: 38),
                        TextFormField(
                          controller: _usernameController,
                          enabled: !authState.isLoading,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Usuário',
                            hintText: 'usuario.teste',
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Informe o usuário.';
                            }
                            return null;
                          },
                          onChanged: (_) => authState.clearError(),
                        ),
                        const SizedBox(height: 18),
                        TextFormField(
                          controller: _passwordController,
                          enabled: !authState.isLoading,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              tooltip: _obscurePassword
                                  ? 'Mostrar senha'
                                  : 'Ocultar senha',
                              onPressed: authState.isLoading
                                  ? null
                                  : () {
                                      setState(() {
                                        _obscurePassword = !_obscurePassword;
                                      });
                                    },
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Informe a senha.';
                            }
                            return null;
                          },
                          onFieldSubmitted: (_) {
                            if (!authState.isLoading) {
                              _submit();
                            }
                          },
                          onChanged: (_) => authState.clearError(),
                        ),
                        if (authState.errorMessage != null) ...[
                          const SizedBox(height: 18),
                          _LoginError(message: authState.errorMessage!),
                        ],
                        const SizedBox(height: 28),
                        AppButton(
                          label: 'Entrar',
                          icon: Icons.login,
                          isLoading: authState.isLoading,
                          onPressed: _submit,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginBackground extends CustomPainter {
  const _LoginBackground();

  @override
  void paint(Canvas canvas, Size size) {
    final topShapePaint = Paint()
      ..color = AppColors.primaryMedium.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;
    final bottomShapePaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.09)
      ..style = PaintingStyle.fill;

    final topShape = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width * 0.72, 0)
      ..cubicTo(
        size.width * 0.58,
        size.height * 0.08,
        size.width * 0.34,
        size.height * 0.06,
        size.width * 0.20,
        size.height * 0.18,
      )
      ..cubicTo(
        size.width * 0.08,
        size.height * 0.28,
        size.width * 0.04,
        size.height * 0.20,
        0,
        size.height * 0.26,
      )
      ..close();
    canvas.drawPath(topShape, topShapePaint);

    final bottomShape = Path()
      ..moveTo(size.width, size.height)
      ..lineTo(size.width * 0.30, size.height)
      ..cubicTo(
        size.width * 0.42,
        size.height * 0.90,
        size.width * 0.70,
        size.height * 0.86,
        size.width * 0.78,
        size.height * 0.74,
      )
      ..cubicTo(
        size.width * 0.88,
        size.height * 0.60,
        size.width * 0.94,
        size.height * 0.72,
        size.width,
        size.height * 0.64,
      )
      ..close();
    canvas.drawPath(bottomShape, bottomShapePaint);

    final routePaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.20)
      ..strokeWidth = 2.1
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final mainRoute = Path()
      ..moveTo(size.width * 0.08, size.height * 0.24)
      ..cubicTo(
        size.width * 0.22,
        size.height * 0.14,
        size.width * 0.38,
        size.height * 0.30,
        size.width * 0.52,
        size.height * 0.18,
      )
      ..cubicTo(
        size.width * 0.66,
        size.height * 0.06,
        size.width * 0.78,
        size.height * 0.16,
        size.width * 0.90,
        size.height * 0.10,
      );
    canvas.drawPath(mainRoute, routePaint);

    final dashedRoute = Path()
      ..moveTo(size.width * 0.20, size.height * 0.80)
      ..cubicTo(
        size.width * 0.38,
        size.height * 0.68,
        size.width * 0.55,
        size.height * 0.90,
        size.width * 0.82,
        size.height * 0.72,
      );
    _drawDashedPath(
      canvas,
      dashedRoute,
      routePaint..color = AppColors.primaryDark.withValues(alpha: 0.16),
    );

    _drawDotGrid(canvas, Offset(size.width * 0.12, size.height * 0.70));
    _drawLocationMarker(canvas, Offset(size.width * 0.84, size.height * 0.23));
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    const dashLength = 10.0;
    const gapLength = 8.0;

    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final end = (distance + dashLength).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance += dashLength + gapLength;
      }
    }
  }

  void _drawDotGrid(Canvas canvas, Offset origin) {
    final dotPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.18)
      ..style = PaintingStyle.fill;

    for (var row = 0; row < 4; row++) {
      for (var column = 0; column < 4; column++) {
        canvas.drawCircle(
          origin + Offset(column * 12, row * 12),
          1.7,
          dotPaint,
        );
      }
    }
  }

  void _drawLocationMarker(Canvas canvas, Offset center) {
    final markerPaint = Paint()
      ..color = AppColors.citrus.withValues(alpha: 0.38)
      ..style = PaintingStyle.fill;
    final borderPaint = Paint()
      ..color = AppColors.citrus.withValues(alpha: 0.50)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, 9, markerPaint);
    canvas.drawCircle(center, 15, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LoginBrandMark extends StatelessWidget {
  const _LoginBrandMark();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.primarySoft,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.borderStrong),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.72),
                shape: BoxShape.circle,
              ),
            ),
            const Icon(Icons.alt_route, color: AppColors.primary, size: 40),
            Positioned(
              right: 15,
              top: 15,
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: AppColors.citrus,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.2),
                ),
              ),
            ),
            const Positioned(
              left: 17,
              bottom: 16,
              child: Icon(
                Icons.eco_outlined,
                color: AppColors.primaryMedium,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginError extends StatelessWidget {
  const _LoginError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.canceled,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.canceledText.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline,
            color: AppColors.canceledText,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: AppColors.canceledText),
            ),
          ),
        ],
      ),
    );
  }
}
