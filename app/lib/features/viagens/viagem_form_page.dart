import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_error_state.dart';
import '../../core/widgets/app_loading.dart';
import '../../services/api_client.dart';
import '../../services/dominio_service.dart';
import '../../state/auth_state.dart';
import '../../state/viagem_state.dart';

class ViagemFormPage extends StatefulWidget {
  const ViagemFormPage({super.key});

  @override
  State<ViagemFormPage> createState() => _ViagemFormPageState();
}

class _ViagemFormPageState extends State<ViagemFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _destinoController = TextEditingController();
  final _observacoesController = TextEditingController();
  final _dominioService = DominioService();

  List<String> _finalidades = [];
  List<String> _transportes = [];
  String? _finalidadeSelecionada;
  String? _transporteSelecionado;
  DateTime? _dataIda;
  DateTime? _dataVolta;
  bool _isLoadingOptions = true;
  String? _optionsErrorMessage;

  @override
  void initState() {
    super.initState();
    _loadOptions();
  }

  @override
  void dispose() {
    _destinoController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  Future<void> _loadOptions() async {
    setState(() {
      _isLoadingOptions = true;
      _optionsErrorMessage = null;
    });

    try {
      final results = await Future.wait([
        _dominioService.listarFinalidades(),
        _dominioService.listarTransportes(),
      ]);

      if (!mounted) {
        return;
      }

      setState(() {
        _finalidades = results[0];
        _transportes = results[1];
      });
    } on DominioException catch (error) {
      if (mounted) {
        setState(() => _optionsErrorMessage = error.message);
      }
    } on ApiUnauthorizedException {
      if (mounted) {
        await context.read<AuthState>().expireSession();
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _optionsErrorMessage =
              'Verifique sua conexão com o servidor e tente novamente.';
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingOptions = false);
      }
    }
  }

  Future<void> _selectDate({
    required DateTime? currentValue,
    required ValueChanged<DateTime> onSelected,
  }) async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: currentValue ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 3),
    );

    if (selected != null) {
      onSelected(selected);
    }
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    context.read<ViagemState>().clearError();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final success = await _criarViagem();

    if (!mounted || !success) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Viagem criada com sucesso')));
    Navigator.of(context).pop(true);
  }

  Future<bool> _criarViagem() async {
    try {
      return await context.read<ViagemState>().criarViagem(
        destino: _destinoController.text.trim(),
        dataIda: _dataIda!,
        dataVolta: _dataVolta!,
        finalidade: _finalidadeSelecionada!,
        transporte: _transporteSelecionado!,
        observacoes: _observacoesController.text.trim().isEmpty
            ? null
            : _observacoesController.text.trim(),
      );
    } on ApiUnauthorizedException {
      if (mounted) {
        await context.read<AuthState>().expireSession();
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final viagemState = context.watch<ViagemState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Nova viagem')),
      body: SafeArea(child: _buildBody(viagemState)),
      backgroundColor: AppColors.background,
    );
  }

  Widget _buildBody(ViagemState viagemState) {
    if (_isLoadingOptions) {
      return const AppLoading(message: 'Carregando opções...');
    }

    if (_optionsErrorMessage != null) {
      return AppErrorState(
        title: 'Não foi possível carregar as opções.',
        message: _optionsErrorMessage!,
        onRetry: _loadOptions,
      );
    }

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Informe os dados da solicitação',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 4),
          Text(
            'A viagem será criada com status Agendada.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _destinoController,
            enabled: !viagemState.isSaving,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Destino',
              prefixIcon: Icon(Icons.place_outlined),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Destino é obrigatório';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _DateField(
            label: 'Data de ida',
            value: _dataIda,
            enabled: !viagemState.isSaving,
            onTap: () => _selectDate(
              currentValue: _dataIda,
              onSelected: (value) => setState(() => _dataIda = value),
            ),
            validator: (_) {
              if (_dataIda == null) {
                return 'Selecione a data de ida';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _DateField(
            label: 'Data de volta',
            value: _dataVolta,
            enabled: !viagemState.isSaving,
            onTap: () => _selectDate(
              currentValue: _dataVolta,
              onSelected: (value) => setState(() => _dataVolta = value),
            ),
            validator: (_) {
              if (_dataVolta == null) {
                return 'Selecione a data de volta';
              }
              if (_dataIda != null && _dataVolta!.isBefore(_dataIda!)) {
                return 'A data de volta não pode ser anterior à data de ida';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          const _DateHelperText(),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _finalidadeSelecionada,
            decoration: const InputDecoration(
              labelText: 'Finalidade',
              prefixIcon: Icon(Icons.flag_outlined),
            ),
            items: _finalidades
                .map(
                  (finalidade) => DropdownMenuItem(
                    value: finalidade,
                    child: Text(finalidade),
                  ),
                )
                .toList(),
            onChanged: viagemState.isSaving
                ? null
                : (value) => setState(() => _finalidadeSelecionada = value),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Selecione uma finalidade';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _transporteSelecionado,
            decoration: const InputDecoration(
              labelText: 'Transporte',
              prefixIcon: Icon(Icons.directions_car_outlined),
            ),
            items: _transportes
                .map(
                  (transporte) => DropdownMenuItem(
                    value: transporte,
                    child: Text(transporte),
                  ),
                )
                .toList(),
            onChanged: viagemState.isSaving
                ? null
                : (value) => setState(() => _transporteSelecionado = value),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Selecione um transporte';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _observacoesController,
            enabled: !viagemState.isSaving,
            minLines: 3,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Observações',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.notes_outlined),
            ),
          ),
          if (viagemState.errorMessage != null) ...[
            const SizedBox(height: 16),
            _SaveError(message: viagemState.errorMessage!),
          ],
          const SizedBox(height: 24),
          AppButton(
            label: 'Salvar viagem',
            icon: Icons.save_outlined,
            isLoading: viagemState.isSaving,
            onPressed: _save,
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _DateHelperText extends StatelessWidget {
  const _DateHelperText();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.info_outline,
          size: 16,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            'A data de volta não pode ser anterior à data de ida.',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.enabled,
    required this.onTap,
    required this.validator,
  });

  final String label;
  final DateTime? value;
  final bool enabled;
  final VoidCallback onTap;
  final FormFieldValidator<String> validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      enabled: enabled,
      controller: TextEditingController(
        text: value == null ? '' : DateFormatter.date(value!),
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.calendar_today_outlined),
        suffixIcon: const Icon(Icons.expand_more),
      ),
      onTap: enabled ? onTap : null,
      validator: validator,
    );
  }
}

class _SaveError extends StatelessWidget {
  const _SaveError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.canceled,
        borderRadius: BorderRadius.circular(8),
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
