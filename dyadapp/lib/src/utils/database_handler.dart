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
      onOpen: _onOpen,
    );
  }

  FutureOr<void> _onOpen(Database db) async {}

  Future<void> _onCreate(Database db, int version) async {
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
        lastUpdated TEXT,
        id INTEGER PRIMARY KEY
      )
    ''');
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<void> clearData() async {
    final db = await _helperInstance.database;
    db.rawDelete('DELETE FROM posts');
  }

  Future<int> insertPost(Post post) async {
    final db = await _helperInstance.database;
    int id;
    if (post.hasId()) {
      id = await db.insert(
        'posts',
        {
          "id": post.id,
          "author": post.author,
          "data": post.writeToBuffer(),
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    } else {
      id = await db.insert(
        'posts',
        {
          "author": post.author,
          "data": post.writeToBuffer(),
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );

    }
    print("INSERTING POST: $id");
    return id;
  }

  Future<List<Post>> posts() async {
    final db = await _helperInstance.database;
    final List<Map<String, dynamic>> maps = await db.query('posts');
    return List.generate(maps.length, (idx) {
      var post = Post.fromBuffer(maps[idx]['data']);
      post.id = maps[idx]['id'];
      return post;
    });
  }

  Future<Post?> getPost(String? queryId) async {
    if (queryId == null) return null;
    final db = await _helperInstance.database;
    final List<Map<String, dynamic>> maps =
        await db.query('posts', where: 'id = ?', whereArgs: [queryId]);
    return maps.isNotEmpty ? Post.fromBuffer(maps[0]['data']) : null;
  }

  Future<List<Post>> getAuthorPosts(String? author) async {
    if (author == null) return [];
    final db = await _helperInstance.database;
    final List<Map<String, dynamic>> maps =
        await db.query('posts', where: 'author = ?', whereArgs: [author]);
    return List.generate(
        maps.length, (idx) => Post.fromBuffer(maps[idx]['data']));
  }

  Future<void> updatePost(int id, Post post) async {
    final db = await _helperInstance.database;
    print("UPDATING POST: $id ==? ${post.id}");
    await db.update(
      'posts',
      {'author': post.author, 'data': post.writeToBuffer()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deletePost(int id) async {
    final db = await _helperInstance.database;
    await db.delete(
      'posts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> insertMessage(Message message) async {
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

  Future<List<Message>> messages() async {
    final db = await _helperInstance.database;
    final List<Map<String, dynamic>> maps = await db.query('posts');
    return List.generate(
        maps.length, (idx) => Message.fromBuffer(maps[idx]['data']));
  }

  Future<void> updateMessage(Message message) async {
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

  Future<void> deleteMessage(Message message) async {
    final db = await _helperInstance.database;
    await db.delete(
      'posts',
      where: 'id = ?',
      whereArgs: [message.id],
    );
  }

  Future<List<Chat>> chats() async {
    final db = await _helperInstance.database;
    final List<Map<String, dynamic>> maps = await db.query('chats');
    return List.generate(maps.length, (idx) {
      var chat = Chat.fromBuffer(maps[idx]['data']);
      chat.id = maps[idx]['id'];
      return chat;
    });
  }

  Future<void> insertChat(Chat chat) async {
    final db = await _helperInstance.database;
    await db.insert('chats', {
      'recpients': chat.recipients,
      'data': chat.messages,
      'lastUpdated': chat.lastUpdated
    });
  }

  Future<void> deleteChat(Chat chat) async {
    final db = await _helperInstance.database;
    await db.delete(
      'chats',
      where: 'id = ?',
      whereArgs: [chat.id],
    );
  }

  Future<void> updateChat(Chat chat) async {
    final db = await _helperInstance.database;
    await db.update(
      'chats',
      {
        'id': chat.id,
        'author': chat.recipients,
        'data': chat.writeToBuffer(),
        'lastUpdated': chat.lastUpdated
      },
      where: 'id = ?',
      whereArgs: [chat.id],
    );
  }

  Future<Chat?> getChat(String? queryId) async {
    if (queryId == null) return null;
    final db = await _helperInstance.database;
    final List<Map<String, dynamic>> maps =
        await db.query('chats', where: 'id = ?', whereArgs: [queryId]);

    return maps.isNotEmpty ? Chat.fromBuffer(maps[0]['data']) : null;
  }
}
