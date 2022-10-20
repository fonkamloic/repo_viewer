import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oauth2/src/credentials.dart';
import 'package:repo_viewer/auth/infrastructure/credential_storage/credentials_storage.dart';

class SecureCredentialsStorage implements CredentialsStorage {
  final FlutterSecureStorage _storage;
  static const _key = 'oauth2_credentials';

  Credentials? _cachedCredentials;

  SecureCredentialsStorage(this._storage);
  @override
  Future<void> save(Credentials credentials) {
    return _storage.write(key: _key, value: credentials.toJson());
  }

  @override
  Future<Credentials?> read() async {
    if (_cachedCredentials != null) {
      return _cachedCredentials;
    }
    final jsonKey = await _storage.read(key: _key);
    if (jsonKey == null) return null;
    try {
      return _cachedCredentials = Credentials.fromJson(jsonKey);
    } on FormatException {
      return null;
    }
  }

  @override
  Future<void> clear() {
    _cachedCredentials = null;
    return _storage.delete(key: _key);
  }
}
