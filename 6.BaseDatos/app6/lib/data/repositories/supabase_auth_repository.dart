import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/repositories/auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  final _auth = Supabase.instance.client.auth;

  @override
  Future<String> registrar(String correo, String clave) async {
    final response = await _auth.signUp(email: correo, password: clave);
    final user = response.user;

    if (user == null) {
      throw StateError('No se pudo obtener el usuario registrado.');
    }

    return user.id;
  }

  @override
  Future<void> ingresar(String correo, String clave) async {
    await _auth.signInWithPassword(email: correo, password: clave);
  }

  @override
  Future<void> salir() async {
    await _auth.signOut();
  }

  @override
  String? obtenerIdActual() {
    return _auth.currentUser?.id;
  }
}