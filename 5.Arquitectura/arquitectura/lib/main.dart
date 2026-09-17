import 'package:flutter/material.dart';

import 'data/repositories/usuario_memoria.dart';
import 'domain/entities/usuario.dart';
import 'domain/usecases/obtener_usuarios_con_vocal.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final usuarioMemoria = UsuarioMemoria();
    final obtenerUsuariosConVocal = ObtenerUsuariosConVocal(usuarioMemoria);

    return MaterialApp(
      title: 'Usuarios con vocales',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: UsersPage(
        obtenerUsuariosConVocal: obtenerUsuariosConVocal,
      ),
    );
  }
}

class UsersPage extends StatefulWidget {
  const UsersPage({super.key, required this.obtenerUsuariosConVocal});

  final ObtenerUsuariosConVocal obtenerUsuariosConVocal;

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late Future<List<Usuario>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = _loadUsers();
  }

  Future<List<Usuario>> _loadUsers() {
    return widget.obtenerUsuariosConVocal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios con vocales'),
        actions: [
          IconButton(
            onPressed: () => setState(() => _usersFuture = _loadUsers()),
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar usuarios',
          ),
        ],
      ),
      body: FutureBuilder<List<Usuario>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cloud_off, size: 48),
                    const SizedBox(height: 12),
                    const Text('No se pudieron cargar los usuarios'),
                    const SizedBox(height: 12),
                    FilledButton.icon(
                      onPressed: () =>
                          setState(() => _usersFuture = _loadUsers()),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          final users = snapshot.data ?? [];
          if (users.isEmpty) {
            return const Center(
              child: Text('No hay usuarios cuyo nombre empiece con vocal.'),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final user = users[index];

              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(user.nombre[0].toUpperCase()),
                  ),
                  title: Text(user.nombre),
                  subtitle: Text(user.email),
                ),
              );
            },
          );
        },
      ),
    );
  }
}