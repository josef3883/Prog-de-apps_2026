import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xff101114),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xfff59e0b),
          brightness: Brightness.dark,
        ),
      ),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _display = '0';
  double? _storedValue;
  String? _operator;
  bool _startsNewNumber = true;

  void _press(String value) {
    setState(() {
      if (value == 'C') {
        _display = '0';
        _storedValue = null;
        _operator = null;
        _startsNewNumber = true;
      } else if (value == '+/-') {
        if (_display != '0' && _display != 'Error') {
          _display = _display.startsWith('-')
              ? _display.substring(1)
              : '-$_display';
        }
      } else if (value == '=') {
        _calculate();
      } else if ('+-x/'.contains(value)) {
        _storedValue = double.tryParse(_display);
        _operator = value;
        _startsNewNumber = true;
      } else if (value == '.') {
        if (_startsNewNumber) {
          _display = '0.';
          _startsNewNumber = false;
        } else if (!_display.contains('.')) {
          _display += '.';
        }
      } else if (_display == 'Error') {
        _display = value;
        _startsNewNumber = false;
      } else {
        if (_startsNewNumber || _display == '0') {
          _display = value;
          _startsNewNumber = false;
        } else if (_display.replaceAll('-', '').replaceAll('.', '').length < 12) {
          _display += value;
        }
      }
    });
  }

  void _calculate() {
    final left = _storedValue;
    final right = double.tryParse(_display);
    if (left == null || right == null || _operator == null) return;

    double result;
    switch (_operator) {
      case '+':
        result = left + right;
      case '-':
        result = left - right;
      case 'x':
        result = left * right;
      case '/':
        if (right == 0) {
          _display = 'Error';
          _storedValue = null;
          _operator = null;
          _startsNewNumber = true;
          return;
        }
        result = left / right;
      default:
        return;
    }
    _display = _formatNumber(result);
    _storedValue = null;
    _operator = null;
    _startsNewNumber = true;
  }

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toStringAsFixed(8).replaceFirst(RegExp(r'0+$'), '');
  }

  Widget _button(String label, {Color? color, Color? textColor}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: SizedBox(
          height: 68,
          child: ElevatedButton(
            onPressed: () => _press(label),
            style: ElevatedButton.styleFrom(
              backgroundColor: color ?? const Color(0xff202328),
              foregroundColor: textColor ?? Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: Text(
              label,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(List<String> labels) {
    return Row(
      children: [
        for (final label in labels)
          _button(
            label,
            color: label == '='
                ? const Color(0xfff59e0b)
                : label == 'C' || label == '+/-'
                    ? const Color(0xff343a40)
                    : null,
            textColor: label == '=' ? const Color(0xff161616) : null,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 28, 28, 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'CALCULADORA',
                    style: TextStyle(
                      color: Color(0xfff59e0b),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _press('C'),
                    tooltip: 'Limpiar',
                    icon: const Icon(Icons.backspace_outlined),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      _display,
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
              child: Column(
                children: [
                  _row(['C', '+/-', '/', 'x']),
                  _row(['7', '8', '9', '-']),
                  _row(['4', '5', '6', '+']),
                  _row(['1', '2', '3', '=']),
                  _row(['0', '.', '+/-', '=']),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
