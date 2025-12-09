import 'package:drift/drift.dart';
import '../../../core/database/connection/connection.dart';
import 'local_db_schema.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    CoursesTable,
    UnitsTable,
    LessonsTable,
    LocalProgressTable,
    PendingRequestsTable,
    OfflineAssetsTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? e]) : super(e ?? openConnection());

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(pendingRequestsTable);
        }
        if (from < 3) {
          await m.createTable(offlineAssetsTable);
        }
        if (from < 4) {
          // Purge tables to fix corrupted JSON data in IndexedDB
          await m.deleteTable(lessonsTable.actualTableName);
          await m.createTable(lessonsTable);
          await m.deleteTable(unitsTable.actualTableName);
          await m.createTable(unitsTable);
          await m.deleteTable(coursesTable.actualTableName);
          await m.createTable(coursesTable);
        }
      },
    );
  }
}
