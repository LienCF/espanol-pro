import 'package:drift/drift.dart';
import 'package:drift/web.dart';

QueryExecutor openConnection() {
  // Use WebDatabase with IndexedDB storage.
  // Requires sql-wasm.js and sql-wasm.wasm in web/ folder.
  return WebDatabase.withStorage(DriftWebStorage.indexedDb('espanol_pro'));
}
