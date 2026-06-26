import 'package:drift/native.dart';
import 'package:spending_docs/database/app_database.dart';

/*
  This is a proposition to the future. Currently

  THIS CLASS IS NOT USED

*/

class DatabaseHelper {
  late AppDatabase _db;

  DatabaseHelper() {
    _db = AppDatabase(NativeDatabase.memory());
  }

  AppDatabase get db => _db;

  Future<void> close() async {
    await _db.close();
  }
}
