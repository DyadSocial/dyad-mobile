import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Database Models
import '../data.dart';

// Post Table - Column
final String tablePosts = 'posts';
final String columnPostsId = 'id';
final String columnPostsTitle = 'title';
final String columnPostsContent = 'content';
final String columnPostsTimestamp = 'timestamp';
final String columnPostsAuthor = 'author';
final String columnPostsImage = 'image;';

class DatabaseHandler {
  // Database singletons
  DatabaseHandler._constructor();
  static final DatabaseHandler _databaseHandler =
      DatabaseHandler._constructor();
  static Database? _database;

  Future<Database> get database async {
    return _database ??= await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    var database = await openDatabase(
      join(await getDatabasesPath(), "post_database.db"),
      onCreate: (db, version) => db.execute("CREATE TABLE $tablePosts("
          "$columnPostsId INTEGER PRIMARY KEY,"
          "$columnPostsTitle TEXT NOT NULL,"
          "$columnPostsContent TEXT NOT NULL,"
          "$columnPostsTimestamp TEXT NOT NULL,"
          "$columnPostsAuthor TEXT NOT NULL,"
          "$columnPostsImage BLOB)"),
      version: 1,
    );
    return database;
  }

  Future<Post?> getPost(int id) async {
    var client = await database;
    List<Map<String, dynamic>> query = await client.query(tablePosts,
        columns: [
          columnPostsId,
          columnPostsTitle,
          columnPostsContent,
          columnPostsAuthor,
          columnPostsImage
        ],
        where: 'columnId = ?',
        whereArgs: [id]);
    if (query.length > 0) {
      return Post.fromMap(query.first);
    }
    return null;
  }
}
