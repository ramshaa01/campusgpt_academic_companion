import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:uuid/uuid.dart';
import '../models/app_models.dart';
import 'storage_service.dart';

class AuthService {
  AuthService(this._storage);

  final StorageService _storage;
  static const _usersKey = 'auth_users';
  static const _sessionKey = 'auth_session';
  static const _seededKey = 'auth_seeded';

  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password.trim())).toString();
  }

  Future<void> ensureDemoAccount() async {
    if (_storage.prefs.getBool(_seededKey) == true) return;

    final users = [
      UserAccount(
        id: 'demo-alex',
        name: 'Alex',
        email: 'alex@campus.edu',
        passwordHash: _hashPassword('demo123'),
      ),
    ];
    await _storage.setJsonList(_usersKey, users.map((u) => u.toJson()).toList());
    await _storage.prefs.setBool(_seededKey, true);
  }

  Future<List<UserAccount>> _loadUsers() async {
    return _storage
        .getJsonList(_usersKey)
        .map(UserAccount.fromJson)
        .toList();
  }

  Future<UserAccount?> currentUser() async {
    final sessionId = _storage.getString(_sessionKey);
    if (sessionId == null) return null;
    final users = await _loadUsers();
    return users.cast<UserAccount?>().firstWhere(
          (u) => u?.id == sessionId,
          orElse: () => null,
        );
  }

  Future<UserAccount> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (name.trim().length < 2) {
      throw AuthException('Name must be at least 2 characters.');
    }
    if (!normalizedEmail.contains('@')) {
      throw AuthException('Enter a valid email address.');
    }
    if (password.length < 6) {
      throw AuthException('Password must be at least 6 characters.');
    }

    final users = await _loadUsers();
    if (users.any((u) => u.email.toLowerCase() == normalizedEmail)) {
      throw AuthException('An account with this email already exists.');
    }

    final user = UserAccount(
      id: const Uuid().v4(),
      name: name.trim(),
      email: normalizedEmail,
      passwordHash: _hashPassword(password),
    );
    users.add(user);
    await _storage.setJsonList(_usersKey, users.map((u) => u.toJson()).toList());
    await _storage.setString(_sessionKey, user.id);
    return user;
  }

  Future<UserAccount> signIn({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final users = await _loadUsers();
    final hash = _hashPassword(password);
    final user = users.cast<UserAccount?>().firstWhere(
          (u) =>
              u!.email.toLowerCase() == normalizedEmail &&
              u.passwordHash == hash,
          orElse: () => null,
        );
    if (user == null) {
      throw AuthException('Invalid email or password.');
    }
    await _storage.setString(_sessionKey, user.id);
    return user;
  }

  Future<void> signOut() => _storage.remove(_sessionKey);
}

class AuthException implements Exception {
  AuthException(this.message);
  final String message;

  @override
  String toString() => message;
}

