import 'dart:async';
import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

QueryExecutor openConnection() {
  return DatabaseConnection.delayed(Future(() async {
    try {
      final result = await WasmDatabase.open(
        databaseName: 'espanol_pro',
        sqlite3Uri: Uri.parse('sqlite3.wasm'),
        driftWorkerUri: Uri.parse('drift_worker.js'),
      );

      if (result.missingFeatures.isNotEmpty) {
        print('Missing WASM features: ${result.missingFeatures}');
      }

      return result.resolvedExecutor;
    } catch (e, stack) {
      print('Failed to initialize WasmDatabase: $e');
      print(stack);
      throw e;
    }
  }));
}
