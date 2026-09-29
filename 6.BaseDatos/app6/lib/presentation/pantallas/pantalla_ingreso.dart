import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/sesion_provider.dart';
import 'pantalla_usuarios.dart';

class PantallaIngreso extends StatefulWidget {
  const PantallaIngreso({super.key});

  @override
  State<PantallaIngreso> createState() => _PantallaIngresoState();
}

class _PantallaIngresoState extends State<PantallaIngreso> {
  final correo = TextEditingController();
  final clave = TextEditingController();
  final nombre = TextEditingController();
  late final SesionProvider _sesionProvider;

  @override
  void initState() {
    super.initState();
    _sesionProvider = context.read<SesionProvider>();
    _sesionProvider.addListener(_navegarSiHaySesion);
  }

  @override
  void dispose() {
    _sesionProvider.removeListener(_navegarSiHaySesion);
    correo.dispose();
    clave.dispose();
    nombre.dispose();
    super.dispose();
  }

  void _navegarSiHaySesion() {
    if (!mounted || context.read<SesionProvider>().idUsuario == null) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const PantallaUsuarios()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final sesion = context.watch<SesionProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Ingreso')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: correo,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Correo'),
            ),
            TextField(
              controller: clave,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Clave'),
            ),
            TextField(
              controller: nombre,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            if (sesion.error != null)
              Text(
                sesion.error!,
                style: const TextStyle(color: Colors.red),
              ),
            if (sesion.cargando) const CircularProgressIndicator(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: sesion.cargando
                        ? null
                        : () => context.read<SesionProvider>().ingresar(
                              correo.text,
                              clave.text,
                            ),
                    child: const Text('Ingresar'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: sesion.cargando
                        ? null
                        : () => context.read<SesionProvider>().registrar(
                              correo.text,
                              clave.text,
                              nombre.text,
                            ),
                    child: const Text('Crear cuenta'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}