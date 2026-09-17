import '../../domain/entities/usuario.dart';
import '../../domain/repositories/usuario_repository.dart';

class UsuarioMemoria implements UsuarioRepository {
  @override
  Future<List<Usuario>> obtener() async {
    return const [
      Usuario(
        id: 1,
        nombre: 'Ana Torres',
        email: 'ana.torres@example.com',
      ),
      Usuario(
        id: 2,
        nombre: 'Bruno Diaz',
        email: 'bruno.diaz@example.com',
      ),
      Usuario(
        id: 3,
        nombre: 'Elena Ruiz',
        email: 'elena.ruiz@example.com',
      ),
    ];
  }
}
