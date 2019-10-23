import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:todolist/Database/Model.dart';
import 'package:todolist/bloc.dart';

class DatabaseHelper {
  static Database _db;
  String table = 'todo';
  String columnId = 'id';
  String columnTitle = 'title';
  String columnDesc = 'desc';
  String columnTime = 'Time';
  String columnDid = 'did';

  void _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $table ($columnId INTEGER PRIMARY KEY, $columnTitle TEXT, $columnDesc TEXT,$columnTime TEXT,$columnDid TEXT)');
  } // to create the table (command)

  intDB() async {
    Directory d = await getApplicationDocumentsDirectory();
    String p = join(d.path, 'MyDB.db');
    var Mydb = await openDatabase(p, version: 1, onCreate: _onCreate);
    return Mydb;
  } // to get the path of the application and then create the db depending on the path

  Future<Database> get db async {
    if (_db != null) return _db;
    _db = await intDB();
    return _db;
  } // to check if db null or not , if null we create one

  Future<int> SaveTodo(Todo todo) async {
    var cdb = await db;
    int res = await cdb.insert(table, todo.toMap());
    return res;
  }

  Future<List> getTodos() async {
    var cdb = await db;
    List res = await cdb.rawQuery('select * from $table ORDER BY id DESC');
    return res.toList();
  }

  Future<int> getCount() async {
    var cdb = await db;

    return Sqflite.firstIntValue(
        await cdb.rawQuery('select count(*) from $table where did = 1'));
  }

  Future<Todo> getTodo(int id) async {
    var cdb = await db;
    String cmd = 'select * from $table where id = $id';
    var res = await cdb.rawQuery(cmd);

    if (res.length == 0) return null;
    return new Todo.fromMap(res.first);
  }

  Future<int> deleteTodo(int id) async {
    var dbClient = await db;
    int res =
        await dbClient.delete(table, where: "$columnId = ?", whereArgs: [id]);
    bloc.fetchAllTodos();
    bloc.fetchCount();
    return res;
  }

  Future<int> updateTodo(var todo) async {
    Todo t = await getTodo(todo['id']);
    if (t.did == '1')
      t.did = '0';
    else
      t.did = '1';
    var dbClient = await db;
    int res = await dbClient.update(table, t.toMap(),
        where: "$columnId = ?", whereArgs: [todo['id']]);
    bloc.fetchAllTodos();
    bloc.fetchCount();
    return res;
    //return dbClient.rawUpdate('UPDATE $table SET  $columnDid WHERE id = ?',[todo['did'],todo['id']]);
  }

  Future<void> close() async {
    var dbClient = await db;
    return await dbClient.close();
  }
}
