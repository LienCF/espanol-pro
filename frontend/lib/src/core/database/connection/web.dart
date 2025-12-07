import 'package:drift/drift.dart';
import 'package:drift/web.dart';

QueryExecutor openConnection() {
  // Use WebDatabase which attempts to use WASM or falls back if configured.
  // Note: Requires sqlite3.wasm in web/ for WASM support.
  return WebDatabase('espanol_pro', logStatements: true);
}
