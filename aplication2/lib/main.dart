import 'package:flutter/material.dart';

void main() {
  runApp(const CalculadoraApp());
}

class CalculadoraApp extends StatelessWidget {
  const CalculadoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculadora',
      theme: ThemeData.dark(),
      home: const CalculadoraHomePage(),
    );
  }
}

class CalculadoraHomePage extends StatefulWidget {
  const CalculadoraHomePage({super.key});

  @override
  State<CalculadoraHomePage> createState() => _CalculadoraHomePageState();
}

class _CalculadoraHomePageState extends State<CalculadoraHomePage> {
  String _pantalla = '0';
  double _num1 = 0;
  double _num2 = 0;
  String _operacion = '';
  bool _nuevaOperacion = false;

  void _botonPresionado(String texto) {
    setState(() {
      if (texto == 'C') {
        _pantalla = '0';
        _num1 = 0;
        _num2 = 0;
        _operacion = '';
        _nuevaOperacion = false;
      } else if (texto == '+' || texto == '-' || texto == '×' || texto == '÷') {
        _num1 = double.parse(_pantalla);
        _operacion = texto;
        _nuevaOperacion = true;
      } else if (texto == '=') {
        if (_operacion.isNotEmpty) {
          _num2 = double.parse(_pantalla);

          switch (_operacion) {
            case '+':
              _pantalla = (_num1 + _num2).toString();
              break;
            case '-':
              _pantalla = (_num1 - _num2).toString();
              break;
            case '×':
              _pantalla = (_num1 * _num2).toString();
              break;
            case '÷':
              _pantalla = _num2 != 0 
                  ? (_num1 / _num2).toString() 
                  : 'Error';
              break;
          }

          // Eliminar el decimal .0 si es un número entero
          if (_pantalla.endsWith('.0')) {
            _pantalla = _pantalla.substring(0, _pantalla.length - 2);
          }

          _operacion = '';
          _nuevaOperacion = true;
        }
      } else if (texto == '.') {
        if (!_pantalla.contains('.')) {
          _pantalla += '.';
        }
      } else {
        // Presión de un dígito (0-9)
        if (_pantalla == '0' || _nuevaOperacion) {
          _pantalla = texto;
          _nuevaOperacion = false;
        } else {
          _pantalla += texto;
        }
      }
    });
  }

  Widget _crearBoton(String texto, {Color? colorFondo, Color textoColor = Colors.white}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorFondo ?? Colors.grey[850],
            padding: const EdgeInsets.all(22.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
          onPressed: () => _botonPresionado(texto),
          child: Text(
            texto,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: textoColor,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          // Pantalla de la calculadora
          Expanded(
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              child: Text(
                _pantalla,
                style: const TextStyle(
                  fontSize: 48.0,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
              ),
            ),
          ),
          const Divider(height: 1),
          // Botones de la calculadora
          Column(
            children: [
              Row(
                children: [
                  _crearBoton('C', colorFondo: Colors.redAccent),
                  _crearBoton('÷', colorFondo: Colors.orange),
                ],
              ),
              Row(
                children: [
                  _crearBoton('7'),
                  _crearBoton('8'),
                  _crearBoton('9'),
                  _crearBoton('×', colorFondo: Colors.orange),
                ],
              ),
              Row(
                children: [
                  _crearBoton('4'),
                  _crearBoton('5'),
                  _crearBoton('6'),
                  _crearBoton('-', colorFondo: Colors.orange),
                ],
              ),
              Row(
                children: [
                  _crearBoton('1'),
                  _crearBoton('2'),
                  _crearBoton('3'),
                  _crearBoton('+', colorFondo: Colors.orange),
                ],
              ),
              Row(
                children: [
                  _crearBoton('0'),
                  _crearBoton('.'),
                  _crearBoton('=', colorFondo: Colors.green),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}