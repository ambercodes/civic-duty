class AuthService {
  const AuthService({this.tokenProvider});

  final Future<String?> Function()? tokenProvider;

  Future<String?> idToken() {
    final provider = tokenProvider;
    if (provider == null) {
      return Future<String?>.value();
    }
    return provider();
  }
}
