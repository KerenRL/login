import '../domain/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<bool> login(String email, String password) async {
    // Simulamos una petición a una API
    await Future.delayed(const Duration(seconds: 2));
    if (email == "admin@mail.com" && password == "123456") {
      return true;
    }
    return false;
  }
}
