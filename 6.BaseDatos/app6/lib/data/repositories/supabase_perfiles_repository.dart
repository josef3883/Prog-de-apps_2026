import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/perfil.dart';
import '../../domain/repositories/perfiles_repository.dart';

class SupabasePerfilesRepository implements PerfilesRepository {
  final _perfiles = Supabase.instance.client.from('perfiles');

  @override
  Future<void> crear(String id, String nombre) async {
    await _perfiles.insert({'id': id, 'nombre': nombre});
  }

  @override
  Future<List<Perfil>> obtenerTodos() async {
    final respuesta = await _perfiles.select();
    return (respuesta as List<dynamic>)
        .map((fila) => _convertirPerfil(fila as Map<String, dynamic>))
        .toList();
  }

  Perfil _convertirPerfil(Map<String, dynamic> fila) {
    return Perfil(
      id: fila['id'] as String,
      nombre: fila['nombre'] as String,
      creadoEn: DateTime.parse(fila['creado_en'] as String),
    );
  }
}