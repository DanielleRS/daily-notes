import 'package:daily_notes/model/Annotation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AnnotationHelper {
  static final String tableName = "annotation";
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
      _db = await initializeDB();
      return _db;
    }
  }

  _onCreate(Database db, int version) async {
    String sql = "CREATE TABLE $tableName ("
    "id INTEGER PRIMARY KEY AUTOINCREMENT, "
    "title VARCHAR, "
    "description TEXT, "
    "date DATETIME)";
    await db.execute(sql);
  }

  initializeDB() async {
    final databasePath = await getDatabasesPath();
    final localDatabase = join(databasePath, "bank_daily_notes.db");
    
    var db = await openDatabase(localDatabase, version: 1, onCreate: _onCreate);
    return db;
  }

  Future<int> saveAnnotation(Annotation annotation) async {
    var database = await db;
    int result = await database.insert(tableName, annotation.toMap());
    return result;
  }
}