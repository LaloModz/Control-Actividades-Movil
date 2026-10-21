import 'package:aprende_mas/config/utils/catalog_enums.dart';
import 'package:aprende_mas/models/models.dart';

class AuthUserMapper {
  static AuthUser userJsonToEntity(Map<String, dynamic> user) => AuthUser(
        userId: user['id'] ?? -1,
        userUuid: user['userId']?.toString() ?? '',
        userName: user['userName'] ?? "",
        email: user['correo'] ?? "",
        role: user['rol'] ?? "",
        token: user['token'] ?? "",
        estaAutorizado: _normalizeAuthStatus(user['estaAutorizado']),
        requiereDatosAdicionales: user['requiereDatosAdicionales'] ?? false,
      );

  static String? _normalizeAuthStatus(dynamic value) {
    if (value == null) return null;
    final raw = value.toString().trim().toLowerCase();
    switch (raw) {
      case 'true':
      case 'autorizado':
      case 'authorized':
        return AuthorizationUserStatus.authorized.value; // autorizado
      case 'false':
      case 'denegado':
      case 'denied':
        return AuthorizationUserStatus.denied.value; // denegado
      case 'pendiente':
      case 'pending':
        return AuthorizationUserStatus.pending.value; // pendiente
      default:
        return value.toString();
    }
  }
}
