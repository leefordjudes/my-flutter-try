import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';

import 'package:todo_riverpod_sqflite/data/data.dart';
import 'package:todo_riverpod_sqflite/utils/utils.dart';

class TaskDatasource {
  static final TaskDatasource _instance = TaskDatasource._();

  factory TaskDatasource() => _instance;

  TaskDatasource._() {
    _initDb();
  }

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    if (Platform.isWindows) {
      final directory = await getApplicationCacheDirectory();
      final dbPath = path.join(directory.path, DBKeys.dbName);
      // C:\Users\Administrator\AppData\Local\com.cjtech\todo_riverpod_sqflite\tasks.db
      sqfliteFfiInit();
      return databaseFactoryFfi.openDatabase(
        dbPath,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: _onCreate,
        ),
      );
    }
    // Platform.isAndroid
    final dbPath = await getDatabasesPath();
    final fullPath = path.join(dbPath, DBKeys.dbName);
    //  /data/user/0/com.cjtech.todo_riverpod_sqflite/databases/tasks.db
    return await openDatabase(
      fullPath,
      version: 1,
      onCreate: _onCreate,
    );
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${DBKeys.dbTable} (
        ${DBKeys.idColumn} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${DBKeys.titleColumn} TEXT,
        ${DBKeys.noteColumn} TEXT,
        ${DBKeys.dateColumn} TEXT,
        ${DBKeys.timeColumn} TEXT,
        ${DBKeys.categoryColumn} TEXT,
        ${DBKeys.isCompletedColumn} INTEGER
      )
    ''');
  }

  Future<int> addTask(Task task) async {
    final db = await database;
    return db.transaction((txn) async {
      return await txn.insert(
        DBKeys.dbTable,
        task.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    });
  }

  Future<List<Task>> getAllTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> data = await db.query(
      DBKeys.dbTable,
      orderBy: "id DESC",
    );
    return List.generate(
      data.length,
      (index) {
        return Task.fromJson(data[index]);
      },
    );
  }

  Future<int> updateTask(Task task) async {
    final db = await database;
    return db.transaction((txn) async {
      return await txn.update(
        DBKeys.dbTable,
        task.toJson(),
        where: 'id = ?',
        whereArgs: [task.id],
      );
    });
  }

  Future<int> deleteTask(Task task) async {
    final db = await database;
    return db.transaction(
      (txn) async {
        return await txn.delete(
          DBKeys.dbTable,
          where: 'id = ?',
          whereArgs: [task.id],
        );
      },
    );
  }
}
