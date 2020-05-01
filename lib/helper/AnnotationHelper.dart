import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AnnotationHelper {
  static final AnnotationHelper _annotationHelper = AnnotationHelper._internal();
  Database _db;

  factory AnnotationHelper() {
    return _annotationHelper;
  }

  AnnotationHelper._internal() {

  }

  get db async {
    if(_db != null) {
      return _db;
    } else {

    }
  }

  _onCreate(Database db, int version) async {
    String sql = "CREATE TABLE annotation (id INTEGER PRIMARY KEY AUTOINCREMENT, title VARCHAR, description TEXT, date DATETIME)";
    await db.execute(sql);
  }

  initializeDB() async {
    final databasePath = await getDatabasesPath();
    final localDatabase = join(databasePath, "bank_daily_notes.db");
    
    var db = await openDatabase(localDatabase, version: 1, onCreate: _onCreate);
    return db;
  }
}