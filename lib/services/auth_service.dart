import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Handles user signup and login using a local SQLite database.
/// Passwords are stored as salted SHA-256 hashes.
class AuthService {
  Database? _db;
  final String? _databasePath;

  static const _tableName = 'users';

  /// Creates an [AuthService].
  ///
  /// Supply [databasePath] to override the default database location
  /// (useful in tests, e.g. pass [inMemoryDatabasePath]).
  AuthService({String? databasePath}) : _databasePath = databasePath;

  Future<Database> get database async {
    _db ??= await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final String path;
    if (_databasePath != null) {
      path = _databasePath!;
    } else {
      final dbPath = await getDatabasesPath();
      path = join(dbPath, 'auth.db');
    }
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password_hash TEXT NOT NULL,
        salt TEXT NOT NULL
      )
    ''');
  }

  String _generateSalt() {
    final rng = Random.secure();
    final bytes = List<int>.generate(16, (_) => rng.nextInt(256));
    return base64Url.encode(bytes);
  }

  String _hashPassword(String password, String salt) {
    final bytes = utf8.encode(password + salt);
    return sha256.convert(bytes).toString();
  }

  /// Validates a username.
  /// Returns an error message, or `null` if valid.
  static String? validateUsername(String username) {
    if (username.isEmpty) return 'Username cannot be empty';
    if (username.length < 3) return 'Username must be at least 3 characters';
    if (username.length > 30) return 'Username must be at most 30 characters';
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(username)) {
      return 'Username may only contain letters, numbers, and underscores';
    }
    return null;
  }

  /// Validates a password against standard requirements.
  /// Returns an error message, or `null` if valid.
  static String? validatePassword(String password) {
    if (password.length < 8) return 'Password must be at least 8 characters';
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  /// Registers a new user.
  /// Returns `null` on success, or an error message on failure.
  Future<String?> signUp(String username, String password) async {
    final usernameError = validateUsername(username);
    if (usernameError != null) return usernameError;

    final passwordError = validatePassword(password);
    if (passwordError != null) return passwordError;

    final db = await database;
    final salt = _generateSalt();
    final hash = _hashPassword(password, salt);

    try {
      await db.insert(_tableName, {
        'username': username,
        'password_hash': hash,
        'salt': salt,
      });
      return null;
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) return 'Username already taken';
      return 'Failed to create account. Please try again.';
    }
  }

  /// Returns `true` if the [username] and [password] match a stored account.
  Future<bool> login(String username, String password) async {
    final db = await database;
    final rows = await db.query(
      _tableName,
      where: 'username = ?',
      whereArgs: [username],
    );

    if (rows.isEmpty) return false;

    final row = rows.first;
    final salt = row['salt'] as String;
    final storedHash = row['password_hash'] as String;
    final hash = _hashPassword(password, salt);
    return hash == storedHash;
  }

  /// Closes the underlying database connection.
  Future<void> close() async {
    final db = _db;
    if (db != null) {
      await db.close();
      _db = null;
    }
  }
}
