import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:spending_docs/core/database/app_database.steps.dart';
import 'package:spending_docs/features/receipt_image/data/daos/receipt_images_dao.dart';
import 'package:spending_docs/features/receipt_image/data/tables/receipt_images_table.dart';
import 'package:spending_docs/features/receipt_items/data/daos/receipt_items_dao.dart';
import 'package:spending_docs/features/receipt_items/data/tables/receipt_items_table.dart';
import 'package:spending_docs/features/receipts/data/daos/receipts_dao.dart';
import 'package:spending_docs/features/receipts/data/tables/receipts_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [Receipts, ReceiptItems, ReceiptImages],
  daos: [ReceiptsDao, ReceiptItemsDao, ReceiptImagesDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e])
    : super(e ?? driftDatabase(name: 'receipts_docs_db.sqlite'));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(onUpgrade: _schemaUpgrade);
  }
}

extension Migrations on GeneratedDatabase {
  OnUpgrade get _schemaUpgrade => stepByStep(
    from1To2: (m, schema) async {
      await m.createTable(schema.receiptImages);
    },
  );
}

/*
// If we plan to switch to lazy loading at some point
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationSupportDirectory();
    final file = File(p.join(dbFolder.path, 'receipts_docs_db.sqlite'));

    return NativeDatabase(file);
  });
}
*/
