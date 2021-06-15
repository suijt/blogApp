import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

import 'blog.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String blogTable = 'blog_table';
  String id = 'id';
  String image = 'image';
  String title = 'title';
  String content = 'content';
  String date = 'date';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'blog.db';
    var blogDatabase = openDatabase(path, version: 1, onCreate: _createDb);
    return blogDatabase;
  } 

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $blogTable($id INTEGER PRIMARY KEY AUTOINCREMENT, $title TEXT, '
        '$content TEXT, $image TEXT, $date TEXT)');
  }

  //get all blogs
  Future<List<Map<String, dynamic>>> getBlogMapList() async {
    Database db = await this.database;
    var result = await db.query(blogTable, orderBy: '$date DESC');
    return result;
  }

  Future<List<Map<String, dynamic>>> getBlogMap(int blogId) async{
    Database db = await this.database;
    var result = await db.rawQuery('SELECT * FROM $blogTable WHERE $id = $blogId');
    return result;
  }

  //insert blog
  Future<int> insertBlog(Blog blog) async {
    Database db = await this.database;
    var result = await db.insert(blogTable, blog.toMap());
    return result;
  }

  //update blog
  Future<int> updateBlog(Blog blog) async {
    var db = await this.database;
    var result = await db.update(blogTable, blog.toMap(),
        where: '$id = ?', whereArgs: [blog.id]);
        print('blog id=== ${blog.id}');
        print('Blog title=== ${blog.title}');
        print('Blog content=== ${blog.content}');
        print('Blog image==== ${blog.image}');
        print('Blog date==== ${blog.date}');

        print('Result is==== $result');
    return result;
  }

  //delete blog
  Future<int> deleteBlog(int blogId) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $blogTable WHERE $id = $blogId');
    return result;
  }

  

  //total number of blogs
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $blogTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  //get single blog
  Future<Blog> getBlog(int id) async{
    var blogMap = await getBlogMap(id);
    int count = blogMap.length;

    List<Blog> blogList = [];
    for (int i = 0; i < count; i++) {
      blogList.add(Blog.fromMapObject(blogMap[i]));
    }

    return blogList[0];

  }

  Future<List<Blog>> getBlogList() async {
    var blogMapList = await getBlogMapList();
    int count = blogMapList.length;

    List<Blog> blogList = [];
    for (int i = 0; i < count; i++) {
      blogList.add(Blog.fromMapObject(blogMapList[i]));
    }

    return blogList;
  }
}
