import 'package:drift/drift.dart';

class CoursesTable extends Table {
  TextColumn get id => text()();
  TextColumn get slug => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get level => text()(); // A1, A2...
  TextColumn get trackType => text()(); // GENERAL or SPECIALIZED
  TextColumn get thumbnailUrl => text().nullable()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  IntColumn get completedLessonsCount => integer().withDefault(const Constant(0))();
  IntColumn get totalLessonsCount => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class UnitsTable extends Table {
  TextColumn get id => text()();
  TextColumn get courseId => text().references(CoursesTable, #id)();
  TextColumn get title => text()();
  IntColumn get orderIndex => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

class LessonsTable extends Table {
  TextColumn get id => text()();
  TextColumn get unitId => text().references(UnitsTable, #id)();
  TextColumn get title => text()();
  TextColumn get contentType => text()();
  TextColumn get contentJson => text().nullable()();
  IntColumn get orderIndex => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

// Track user progress locally (Sync with D1 later)
class LocalProgressTable extends Table {
  TextColumn get lessonId => text().references(LessonsTable, #id)();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  IntColumn get score => integer().nullable()();
  DateTimeColumn get lastUpdated => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {lessonId};
}

class PendingRequestsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get url => text()(); // e.g., '/api/progress'
  TextColumn get method => text()(); // 'POST'
  TextColumn get dataJson => text()(); // JSON body
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class OfflineAssetsTable extends Table {
  TextColumn get url => text()(); // Remote URL (Primary Key)
  TextColumn get localPath => text()(); // Local file system path
  IntColumn get fileSize => integer().nullable()();
  DateTimeColumn get downloadedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {url};
}
