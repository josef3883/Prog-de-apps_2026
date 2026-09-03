import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi App de Contador',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'MI PRIMERA APP'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  // Funciones para modificar el contador
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Imagen desde Internet
            Image.network(
  'https://raw.githubusercontent.com/flutter/website/main/src/assets/images/docs/expressive-ui/flutter-dash.png',
  height: 120,
  fit: BoxFit.contain,
  errorBuilder: (context, error, stackTrace) {
    //Icono en lugar de la imagen
    return const Icon(
      Icons.image_not_supported,
      size: 100,
    );
  },
),
const SizedBox(height: 40),
const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: 30),
   // 2.3 botones
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Botón Restar
                ElevatedButton.icon(
                  onPressed: _decrementCounter,
                  icon: const Icon(Icons.remove),
                  label: const Text('Restar'),
                ),
                const SizedBox(height: 10), // Espacio horizontal

                // Botón Reiniciar
                ElevatedButton.icon(
                  onPressed: _resetCounter,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                ),
                const SizedBox(height: 30),

                // Botón Sumar
                ElevatedButton.icon(
                  onPressed: _incrementCounter,
                  icon: const Icon(Icons.add),
                  label: const Text('Sumar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}