import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/entities/usuario.dart';
import '../../domain/repositories/usuario_repository.dart';

class UsuarioApi implements UsuarioRepository {
  static final Uri _url =
      Uri.parse('https://jsonplaceholder.typicode.com/users');

  @override
  Future<List<Usuario>> obtener() async {
    final response = await http.get(_url);

    if (response.statusCode != 200) {
      throw Exception('No se pudieron obtener los usuarios');
    }

    final usuariosJson = jsonDecode(response.body) as List<dynamic>;

    return usuariosJson.map((usuarioJson) {
      final usuario = usuarioJson as Map<String, dynamic>;
      return Usuario(
        id: usuario['id'] as int,
        nombre: usuario['name'] as String,
        email: usuario['email'] as String,
      );
    }).toList();
  }
}
