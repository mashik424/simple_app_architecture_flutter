abstract class AuthRepository {
  Future<void> register();

  Future<void> login();

  Future<void> logout();
}
