import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/perfiles_provider.dart';
import '../providers/sesion_provider.dart';
import 'pantalla_ingreso.dart';

class PantallaUsuarios extends StatefulWidget {
  const PantallaUsuarios({super.key});

  @override
  State<PantallaUsuarios> createState() => _PantallaUsuariosState();
}

class _PantallaUsuariosState extends State<PantallaUsuarios> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<PerfilesProvider>().cargar();
      }
    });
  }

  Future<void> _salir() async {
    final sesion = context.read<SesionProvider>();
    await sesion.salir();

    if (!mounted) return;
    if (sesion.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(sesion.error!)),
      );
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const PantallaIngreso()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final perfiles = context.watch<PerfilesProvider>();
    final sesion = context.watch<SesionProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios'),
        actions: [
          IconButton(
            onPressed: perfiles.cargando
                ? null
                : context.read<PerfilesProvider>().cargar,
            icon: const Icon(Icons.refresh),
            tooltip: 'Recargar',
          ),
          IconButton(
            onPressed: sesion.cargando ? null : _salir,
            icon: const Icon(Icons.logout),
            tooltip: 'Salir',
          ),
        ],
      ),
      body: _ContenidoPerfiles(perfiles: perfiles),
    );
  }
}

class _ContenidoPerfiles extends StatelessWidget {
  const _ContenidoPerfiles({required this.perfiles});

  final PerfilesProvider perfiles;

  @override
  Widget build(BuildContext context) {
    if (perfiles.cargando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (perfiles.error != null) {
      return Center(
        child: Text(
          perfiles.error!,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    return ListView.builder(
      itemCount: perfiles.perfiles.length,
      itemBuilder: (_, index) {
        final perfil = perfiles.perfiles[index];
        return ListTile(
          title: Text(perfil.nombre),
          subtitle: Text(perfil.creadoEn.toLocal().toString()),
        );
      },
    );
  }
}