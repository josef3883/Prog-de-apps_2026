import 'package:flutter/material.dart';

import '../domain/resultado.dart';
import 'divisor_controller.dart';
import 'formateador_moneda.dart';

class PantallaDivisor extends StatefulWidget {
  const PantallaDivisor({
    super.key,
    required this.controller,
    required this.formateadorMoneda,
  });

  final DivisorController controller;
  final FormateadorMoneda formateadorMoneda;

  @override
  State<PantallaDivisor> createState() => _PantallaDivisorState();
}

class _PantallaDivisorState extends State<PantallaDivisor> {
  static const Color _verde = Color(0xFF174C3C);
  static const Color _coral = Color(0xFFD86F50);
  static const Color _fondo = Color(0xFFF4F5EF);
  static const Color _textoSecundario = Color(0xFF6B7770);

  final TextEditingController _montoController = TextEditingController();
  final TextEditingController _personasController = TextEditingController();
  final TextEditingController _propinaController = TextEditingController();

  late OpcionRedondeo _opcionRedondeo;
  EstadoCalculo? _estadoCalculo;

  @override
  void initState() {
    super.initState();
    _opcionRedondeo = widget.controller.opcionesRedondeo.first;
  }

  @override
  void dispose() {
    _montoController.dispose();
    _personasController.dispose();
    _propinaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resultado = _estadoCalculo?.resultado;
    final error = _estadoCalculo?.error;

    return Scaffold(
      backgroundColor: _fondo,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 32),
              children: [
                _buildHeader(),
                const SizedBox(height: 30),
                Text(
                  'Divide la cuenta',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: const Color(0xFF1B3027),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Tu parte, clara desde el primer cálculo.',
                  style: Theme.of(context).textTheme.bodyLarge
                      ?.copyWith(color: _textoSecundario),
                ),
                const SizedBox(height: 25),
                _buildAmountField(),
                const SizedBox(height: 17),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildDetailField(
                        key: const Key('people-count'),
                        label: 'PERSONAS',
                        hint: '0',
                        icon: Icons.groups_2_outlined,
                        controller: _personasController,
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildDetailField(
                        key: const Key('tip-percent'),
                        label: 'PROPINA',
                        hint: '0',
                        icon: Icons.percent_rounded,
                        controller: _propinaController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'REDONDEO',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: _textoSecundario,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 10),
                SegmentedButton<OpcionRedondeo>(
                  segments: [
                    for (final opcion in widget.controller.opcionesRedondeo)
                      ButtonSegment<OpcionRedondeo>(
                        value: opcion,
                        label: Text(opcion.etiqueta),
                      ),
                  ],
                  selected: {_opcionRedondeo},
                  showSelectedIcon: false,
                  onSelectionChanged: (seleccion) {
                    setState(() {
                      _opcionRedondeo = seleccion.first;
                      _estadoCalculo = null;
                    });
                  },
                  style: SegmentedButton.styleFrom(
                    foregroundColor: _verde,
                    selectedForegroundColor: Colors.white,
                    selectedBackgroundColor: _verde,
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFFDCE2DC)),
                  ),
                ),
                const SizedBox(height: 22),
                FilledButton.icon(
                  onPressed: _calcular,
                  icon: const Icon(Icons.calculate_outlined),
                  label: const Text('Calcular'),
                  style: FilledButton.styleFrom(
                    backgroundColor: _coral,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (error != null) ...[
                  const SizedBox(height: 14),
                  _buildError(widget.controller.mensajeError(error)),
                ],
                if (resultado != null) ...[
                  const SizedBox(height: 22),
                  _buildResult(resultado),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: _verde,
            borderRadius: BorderRadius.circular(13),
          ),
          child: const Icon(Icons.receipt_long_rounded, color: Colors.white),
        ),
        const SizedBox(width: 11),
        Text(
          'cuenta clara',
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(color: _verde, fontWeight: FontWeight.w800),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFE6ECE6),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'RESTAURANTE',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: _verde,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAmountField() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE0E5DF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOTAL DE LA CUENTA',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: _textoSecundario,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            key: const Key('bill-amount'),
            controller: _montoController,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
              signed: true,
            ),
            onChanged: _limpiarResultado,
            style: const TextStyle(
              color: Color(0xFF1B3027),
              fontSize: 34,
              fontWeight: FontWeight.w800,
            ),
            decoration: const InputDecoration(
              hintText: '0.00',
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailField({
    required Key key,
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    required TextInputType keyboardType,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E5DF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 17, color: _verde),
              const SizedBox(width: 6),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: _textoSecundario,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          TextField(
            key: key,
            controller: controller,
            keyboardType: keyboardType,
            onChanged: _limpiarResultado,
            style: const TextStyle(
              color: Color(0xFF1B3027),
              fontSize: 21,
              fontWeight: FontWeight.w700,
            ),
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              suffixText: label == 'PROPINA' ? '%' : null,
              suffixStyle: const TextStyle(
                color: _textoSecundario,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResult(Resultado resultado) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _verde,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Por persona',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFFC9DFD1),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            widget.formateadorMoneda.formatear(
              resultado.importePorPersonaCentimos,
            ),
            key: const Key('share-amount'),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFF527568), height: 1),
          const SizedBox(height: 12),
          _buildSummaryLine(
            'Propina incluida',
            widget.formateadorMoneda.formatear(resultado.propinaCentimos),
          ),
          const SizedBox(height: 7),
          _buildSummaryLine(
            'Total con propina',
            widget.formateadorMoneda.formatear(
              resultado.totalConPropinaCentimos,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String mensaje) {
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF9E8E1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE9B5A3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: Color(0xFF9B452E)),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                mensaje,
                style: const TextStyle(
                  color: Color(0xFF7B3422),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryLine(String label, String amount) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Color(0xFFD8E5DC), fontSize: 14),
          ),
        ),
        Text(
          amount,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  void _limpiarResultado(String _) {
    if (_estadoCalculo != null) {
      setState(() => _estadoCalculo = null);
    }
  }

  void _calcular() {
    setState(() {
      _estadoCalculo = widget.controller.calcular(
        monto: _montoController.text,
        personas: _personasController.text,
        propina: _propinaController.text,
        opcionRedondeo: _opcionRedondeo,
      );
    });
  }
}
