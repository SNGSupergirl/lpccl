import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'library_app.db');
    return openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        library_card_number INTEGER UNIQUE
      )
    ''');
    await db.execute('''
        CREATE TRIGGER generate_library_card_number
        AFTER INSERT ON users
        BEGIN
            UPDATE users SET library_card_number = (SELECT MAX(library_card_number) + 1 FROM users) WHERE id = NEW.id;
        END;
    ''');
    await db.execute('''
    CREATE TABLE books(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      isbn TEXT UNIQUE NOT NULL,
      title TEXT NOT NULL,
      author TEXT,
      // ... other book fields
    )
  ''');
  }

  Future<int> addBook(Map<String, dynamic> bookData) async {
    final db = await database;
    return await db.insert('books', bookData); // Assuming you have a 'books' table
  }

  Future<int> insertUser(String username, String email, String password) async {
    final db = await database;
    return await db.insert('users', {
      'username': username,
      'email': email,
      'password': password,
    });
  }

  Future<int?> getLibraryCardNumber(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query('users', where: 'id = ?', whereArgs: [userId], columns: ['library_card_number']);
    if (result.isNotEmpty) {
      return result.first['library_card_number'] as int?;
    }
    return null;
  }
}
