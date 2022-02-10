import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:dyadapp/src/utils/data/protos/messages.pb.dart';
import 'package:dyadapp/src/utils/data/protos/posts.pb.dart';

// Singleton Database for app
class DatabaseHandler {
  // Single private constructor
  DatabaseHandler._constructor();
  static final DatabaseHandler _helperInstance = DatabaseHandler._constructor();
  // Return the same instance whenever called
  factory DatabaseHandler() => _helperInstance;

  static Database? _database;

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'dyad_database.db');
    try {
      await Directory(databasePath).create(recursive: true);
    } catch (_) {}
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE posts(
        id INTEGER PRIMARY KEY,
        author TEXT,
        data BLOB
      )
    ''');
    await db.execute('''
      CREATE TABLE messages(
        id INTEGER PRIMARY KEY,
        author TEXT,
        data BLOB
      )
    ''');
    await db.execute('''
      CREATE TABLE feed(
        recipients TEXT,
        data BLOB,
        lastUpdated TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE chats(
        recipients TEXT,
        data BLOB,
        lastUpdated TEXT
      )
    ''');
  }

  FutureOr<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  FutureOr<void> insertPost(Post post) async {
    final db = await _helperInstance.database;
    await db.insert(
      'posts',
      {
        "id": post.id,
        "author": post.author,
        "data": post.writeToBuffer(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  FutureOr<List<Post>> posts() async {
    final db = await _helperInstance.database;
    final List<Map<String, dynamic>> maps = await db.query('posts');
    // Convert binary data stored in database into protobuf object
    return List.generate(
        maps.length, (idx) => Post.fromBuffer(maps[idx]['data']));
  }

  FutureOr<void> updatePost(Post post) async {
    final db = await _helperInstance.database;
    await db.update(
      'posts',
      {'id': post.id, 'author': post.author, 'data': post.writeToBuffer()},
      where: 'id = ?',
      whereArgs: [post.id],
    );
  }

  FutureOr<void> deletePost(Post post) async {
    final db = await _helperInstance.database;
    await db.delete(
      'posts',
      where: 'id = ?',
      whereArgs: [post.id],
    );
  }

  FutureOr<void> insertMessage(Message message) async {
    final db = await _helperInstance.database;
    await db.insert(
        'messages',
        {
          "id": message.id,
          "author": message.author,
          "data": message.writeToBuffer()
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  FutureOr<List<Message>> messages() async {
    final db = await _helperInstance.database;
    final List<Map<String, dynamic>> maps = await db.query('posts');
    return List.generate(
        maps.length, (idx) => Message.fromBuffer(maps[idx]['data']));
  }

  FutureOr<void> updateMessage(Message message) async {
    final db = await _helperInstance.database;
    await db.update(
      'messages',
      {
        'id': message.id,
        'author': message.author,
        'data': message.writeToBuffer()
      },
      where: 'id = ?',
      whereArgs: [message.id],
    );
  }

  FutureOr<void> deleteMessage(Message message) async {
    final db = await _helperInstance.database;
    await db.delete(
      'posts',
      where: 'id = ?',
      whereArgs: [message.id],
    );
  }
}
