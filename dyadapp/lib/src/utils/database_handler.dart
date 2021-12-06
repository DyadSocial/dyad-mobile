import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

// Database Models
import 'package:dyadapp/src/data.dart';

// Post Table - Column
final String tablePosts = 'posts';
final String columnPostsId = 'id';
final String columnPostsTitle = 'title';
final String columnPostsContent = 'content';
final String columnPostsTimestamp = 'timestamp';
final String columnPostsAuthor = 'author';
final String columnPostsImage = 'image';

// User Table - Column
final String tableUsers = 'users';
final String columnUserUsername = 'username';
final String columnUserNickname = 'nickname';
final String columnUserProfilePicture = 'profilepicture';
final String columnUserBiography = 'biography';

class DatabaseHandler {
  // Database singletons
  DatabaseHandler._constructor() : super();

  static final DatabaseHandler _databaseHandler =
      DatabaseHandler._constructor();

  static Database? _database;

  factory DatabaseHandler() {
    return _databaseHandler;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await _initDatabase();
    }
    return _database!;
  }

  Future<void> deleteDatabase() async {
    var path = await getDatabasesPath();
    databaseFactory.deleteDatabase(join(path, "post_database.db"));
  }

  Future<Database> _initDatabase() async {
    var path = await getDatabasesPath();
    var database = await openDatabase(
      join(path, "post_database.db"),
      onCreate: (Database db, int version) async {
        db.execute('''
            CREATE TABLE $tablePosts(
            $columnPostsId INTEGER PRIMARY KEY,
            $columnPostsTitle TEXT NOT NULL,
            $columnPostsContent TEXT NOT NULL,
            $columnPostsTimestamp TEXT NOT NULL,
            $columnPostsAuthor TEXT NOT NULL,
            $columnPostsImage BLOB)
            ''');
        db.execute('''
            CREATE TABLE $tableUsers(
            $columnUserUsername TEXT PRIMARY KEY,
            $columnUserNickname TEXT,
            $columnUserProfilePicture BLOB NOT NULL,
            $columnUserBiography TEXT)
            ''');
      },
      version: 7,
    );
    return database;
  }

  Future<User> insertUser(User user) async {
    var client = await database;
    await client.insert(tableUsers, user.toJson());
    return user;
  }

  Future<Post> insertPost(Post post) async {
    var client = await database;
    post.id = await client.insert(tablePosts, post.toJson());
    return post;
  }

  Future<User?> getUser(String username) async {
    var client = await database;
    List<Map<String, dynamic>> query = await client.query(tableUsers,
        columns: [
          columnUserUsername,
          columnUserNickname,
          columnUserBiography,
          columnUserProfilePicture,
        ],
        where: '$columnUserUsername = ?',
        whereArgs: [username]);
    if (query.length > 0) {
      return User.fromJson(query.first);
    }
    return null;
  }

  Future<Post?> getPost(String? id) async {
    if (id == null) return null;
    var client = await database;
    List<Map<String, dynamic>> query = await client.query(tablePosts,
        columns: [
          columnPostsId,
          columnPostsTitle,
          columnPostsContent,
          columnPostsAuthor,
          columnPostsImage,
          columnPostsTimestamp
        ],
        where: '$columnPostsId = ?',
        whereArgs: [id]);
    if (query.length > 0) {
      return Post.fromJson(query.first);
    }
    return null;
  }

  Future<List<Post>?> getPostByUser(String username) async {
    var client = await database;
    List<Map<String, dynamic>> query = await client.query(tablePosts,
        columns: [
          columnPostsId,
          columnPostsTitle,
          columnPostsContent,
          columnPostsAuthor,
          columnPostsImage,
          columnPostsTimestamp
        ],
        where: '$columnPostsAuthor = ?',
        whereArgs: [username]);
    if (query.length > 0) {
      return [for (var post in query) Post.fromJson(post)];
    }
    return null;
  }

  Future<List<User>?> getAllUsers() async {
    var client = await database;
    List<Map<String, dynamic>> query = await client.query(tableUsers, columns: [
      columnUserUsername,
      columnUserNickname,
      columnUserProfilePicture,
      columnUserBiography,
    ]);
    if (query.length > 0) {
      return <User>[for (var user in query) User.fromJson(user)];
    }
  }

  Future<List<Post>> getAllPosts() async {
    var client = await database;
    List<Map<String, dynamic>> query = await client.query(tablePosts, columns: [
      columnPostsId,
      columnPostsTitle,
      columnPostsContent,
      columnPostsAuthor,
      columnPostsImage,
      columnPostsTimestamp
    ]);
    if (query.length > 0) {
      List<Post> posts = [];
      query.forEach((post) {
        posts.add(Post.fromJson(post));
      });
      return posts;
    }
    return [];
  }

  Future<int> updateUser(User user) async {
    var client = await database;
    return await client.update(
      tableUsers,
      user.toJson(),
      where: '$columnUserUsername = ?',
      whereArgs: [user.username],
    );
  }

  Future<int> updatePost(Post post) async {
    var client = await database;
    return await client.update(
      tablePosts,
      post.toJson(),
      where: '$columnPostsId = ?',
      whereArgs: [post.id],
    );
  }

  Future<int> deleteUserUsername(String username) async {
    var client = await database;
    return await client.delete(
      tableUsers,
      where: '$columnUserUsername = ?',
      whereArgs: [username],
    );
  }

  Future<int> deleteUser(User user) async => deleteUserUsername(user.username);

  Future<int> deletePostID(int id) async {
    var client = await database;
    return await client.delete(
      tablePosts,
      where: '$columnPostsId = ?',
      whereArgs: [id],
    );
  }

  Future<int> deletePost(Post post) async => deletePostID(post.id);

  Future<int> deleteAllUsers() async {
    var client = await database;
    return await client.delete(tableUsers);
  }

  Future<int> deleteAllPosts() async {
    var client = await database;
    return await client.delete(tablePosts);
  }

  close() async {
    var client = await database;
    client.close();
  }
}
