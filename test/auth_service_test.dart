import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:my_app/services/auth_service.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  // ──────────────────────────────────────────────────────────────
  // Static validation helpers
  // ──────────────────────────────────────────────────────────────

  group('AuthService.validateUsername', () {
    test('returns error for empty username', () {
      expect(AuthService.validateUsername(''), isNotNull);
    });

    test('returns error when username is too short', () {
      expect(AuthService.validateUsername('ab'), isNotNull);
    });

    test('returns error when username is too long', () {
      expect(AuthService.validateUsername('a' * 31), isNotNull);
    });

    test('returns error for invalid characters', () {
      expect(AuthService.validateUsername('user name'), isNotNull);
      expect(AuthService.validateUsername('user@name'), isNotNull);
    });

    test('returns null for a valid username', () {
      expect(AuthService.validateUsername('alice_42'), isNull);
    });
  });

  group('AuthService.validatePassword', () {
    test('returns error when password is too short', () {
      expect(AuthService.validatePassword('Ab1!'), isNotNull);
    });

    test('returns error when no uppercase letter', () {
      expect(AuthService.validatePassword('alicepass1'), isNotNull);
    });

    test('returns error when no lowercase letter', () {
      expect(AuthService.validatePassword('ALICEPASS1'), isNotNull);
    });

    test('returns error when no digit', () {
      expect(AuthService.validatePassword('AlicePass'), isNotNull);
    });

    test('returns null for a valid password', () {
      expect(AuthService.validatePassword('Secure123'), isNull);
    });
  });

  // ──────────────────────────────────────────────────────────────
  // Database-backed signup & login
  // ──────────────────────────────────────────────────────────────

  group('AuthService signup and login', () {
    late AuthService authService;

    setUp(() {
      // Each test gets a fresh in-memory database.
      authService = AuthService(databasePath: inMemoryDatabasePath);
    });

    tearDown(() async {
      await authService.close();
    });

    test('signUp returns null on success', () async {
      final result = await authService.signUp('alice', 'Secure123');
      expect(result, isNull);
    });

    test('signUp returns error for duplicate username', () async {
      await authService.signUp('alice', 'Secure123');
      final result = await authService.signUp('alice', 'Another1');
      expect(result, isNotNull);
    });

    test('signUp returns error for invalid username', () async {
      final result = await authService.signUp('a', 'Secure123');
      expect(result, isNotNull);
    });

    test('signUp returns error for weak password', () async {
      final result = await authService.signUp('alice', 'password');
      expect(result, isNotNull);
    });

    test('login returns true with correct credentials', () async {
      await authService.signUp('bob', 'Password1');
      final ok = await authService.login('bob', 'Password1');
      expect(ok, isTrue);
    });

    test('login returns false with wrong password', () async {
      await authService.signUp('bob', 'Password1');
      final ok = await authService.login('bob', 'Wrong9999');
      expect(ok, isFalse);
    });

    test('login returns false for unknown username', () async {
      final ok = await authService.login('nobody', 'Password1');
      expect(ok, isFalse);
    });

    test('different users have independent accounts', () async {
      await authService.signUp('alice', 'AlicePass1');
      await authService.signUp('bob', 'BobPass1');

      expect(await authService.login('alice', 'AlicePass1'), isTrue);
      expect(await authService.login('bob', 'BobPass1'), isTrue);
      expect(await authService.login('alice', 'BobPass1'), isFalse);
    });
  });
}
