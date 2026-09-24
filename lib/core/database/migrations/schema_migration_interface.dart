import 'package:drift/drift.dart';

abstract class SchemaMigrationInterface {
  int get fromVersion;
  int get toVersion;

  Future<void> run(Migrator m, GeneratedDatabase db);
}
