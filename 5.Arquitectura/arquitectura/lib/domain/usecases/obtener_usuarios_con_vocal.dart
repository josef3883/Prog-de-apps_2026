import '../entities/usuario.dart';
import '../repositories/usuario_repository.dart';

class ObtenerUsuariosConVocal {
  const ObtenerUsuariosConVocal(this._usuarioRepository);

  final UsuarioRepository _usuarioRepository;

  Future<List<Usuario>> call() async {
    final usuarios = await _usuarioRepository.obtener();
    const vocales = 'aeiou';

    return usuarios.where((usuario) {
      final nombre = usuario.nombre.trim().toLowerCase();
      return nombre.isNotEmpty && vocales.contains(nombre[0]);
    }).toList();
  }
}
