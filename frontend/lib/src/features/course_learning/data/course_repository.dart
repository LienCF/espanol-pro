import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart';
import '../../../core/database/database_provider.dart';
import '../../../core/api/api_client.dart';
import '../../../core/auth/auth_repository.dart';
import '../../../core/services/content_sync_service.dart';
import '../domain/course.dart';
import '../domain/unit.dart';
import '../domain/lesson.dart';
import 'app_database.dart';

part 'course_repository.g.dart';

class CourseRepository {
  final AppDatabase _db;
  final Dio _api;
  final String? _userId;
  final ContentSyncService _syncService;

  CourseRepository(this._db, this._api, this._userId, this._syncService);

  // ... existing stream methods ...
  Stream<List<Course>> watchCourses() {
    return _db.select(_db.coursesTable).watch().map((rows) {
      return rows
          .map(
            (row) => Course(
              id: row.id,
              slug: row.slug,
              title: row.title,
              description: row.description,
              level: row.level,
              trackType: row.trackType,
              thumbnailUrl: row.thumbnailUrl,
              version: row.version,
              completedLessonsCount: row.completedLessonsCount,
              totalLessonsCount: row.totalLessonsCount,
            ),
          )
          .toList();
    });
  }

  Stream<Course?> watchCourse(String courseId) {
    return (_db.select(
      _db.coursesTable,
    )..where((tbl) => tbl.id.equals(courseId))).watchSingleOrNull().map((row) {
      if (row == null) return null;
      return Course(
        id: row.id,
        slug: row.slug,
        title: row.title,
        description: row.description,
        level: row.level,
        trackType: row.trackType,
        thumbnailUrl: row.thumbnailUrl,
        version: row.version,
        completedLessonsCount: row.completedLessonsCount,
        totalLessonsCount: row.totalLessonsCount,
      );
    });
  }

  Stream<List<Unit>> watchUnits(String courseId) {
    return (_db.select(_db.unitsTable)
          ..where((tbl) => tbl.courseId.equals(courseId))
          ..orderBy([(t) => OrderingTerm(expression: t.orderIndex)]))
        .watch()
        .map(
          (rows) => rows
              .map(
                (row) => Unit(
                  id: row.id,
                  courseId: row.courseId,
                  title: row.title,
                  orderIndex: row.orderIndex,
                ),
              )
              .toList(),
        );
  }

  Stream<List<Lesson>> watchLessons(String unitId) {
    final query =
        _db.select(_db.lessonsTable).join([
            leftOuterJoin(
              _db.localProgressTable,
              _db.localProgressTable.lessonId.equalsExp(_db.lessonsTable.id),
            ),
          ])
          ..where(_db.lessonsTable.unitId.equals(unitId))
          ..orderBy([OrderingTerm(expression: _db.lessonsTable.orderIndex)]);

    return query.watch().map((rows) {
      return rows.map((row) {
        final lesson = row.readTable(_db.lessonsTable);
        final progress = row.readTableOrNull(_db.localProgressTable);

        return Lesson(
          id: lesson.id,
          unitId: lesson.unitId,
          title: lesson.title,
          contentType: lesson.contentType,
          contentJson: lesson.contentJson,
          orderIndex: lesson.orderIndex,
          isCompleted: progress?.isCompleted ?? false,
        );
      }).toList();
    });
  }

  Stream<Lesson?> watchLesson(String lessonId) {
    // Simplified query without JOIN to debug WASM type error
    return (_db.select(
      _db.lessonsTable,
    )..where((t) => t.id.equals(lessonId))).watchSingleOrNull().map((row) {
      if (row == null) return null;

      // Note: Progress sync is temporarily disabled in this view stream to fix WASM crash.
      // Progress is still tracked in localProgressTable but not joined here.
      return Lesson(
        id: row.id,
        unitId: row.unitId,
        title: row.title,
        contentType: row.contentType,
        contentJson: row.contentJson,
        orderIndex: row.orderIndex,
        isCompleted: false,
      );
    });
  }

  // Helper methods for safe type conversion
  String _safeString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is Map || value is List) {
      try {
        return jsonEncode(value);
      } catch (e) {
        return value.toString();
      }
    }
    return value.toString();
  }

  int _safeInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Future<void> syncCourses() async {
    if (_userId == null) return;
    try {
      // 1. Fetch all remote courses
      final coursesResponse = await _api.get(
        '/api/courses',
        queryParameters: {'userId': _userId},
      );
      final coursesData = coursesResponse.data as List;

      // 2. Get local courses version map
      final localCourses = await _db.select(_db.coursesTable).get();
      final localVersionMap = {for (var c in localCourses) c.id: c.version};

      // 3. Handle Deletions (Stale courses)
      final remoteCourseIds = coursesData
          .map((c) => _safeString(c['id']))
          .toSet();
      final coursesToDelete = localVersionMap.keys
          .where((id) => !remoteCourseIds.contains(id))
          .toList();

      if (coursesToDelete.isNotEmpty) {
        debugPrint(
          'Deleting ${coursesToDelete.length} stale courses: $coursesToDelete',
        );

        // Delete Lessons of those courses
        final unitsQuery = _db.selectOnly(_db.unitsTable)
          ..addColumns([_db.unitsTable.id])
          ..where(_db.unitsTable.courseId.isIn(coursesToDelete));

        await (_db.delete(
          _db.lessonsTable,
        )..where((l) => l.unitId.isInQuery(unitsQuery))).go();

        // Delete Units
        await (_db.delete(
          _db.unitsTable,
        )..where((u) => u.courseId.isIn(coursesToDelete))).go();

        // Delete Courses
        await (_db.delete(
          _db.coursesTable,
        )..where((c) => c.id.isIn(coursesToDelete))).go();
      }

      final coursesToSync = <String>{};

      await _db.batch((batch) {
        for (final c in coursesData) {
          final remoteVersion = _safeInt(c['version']);
          final localVersion = localVersionMap[_safeString(c['id'])] ?? 0;

          if (remoteVersion > localVersion) {
            coursesToSync.add(_safeString(c['id']));
          }

          // Always update course metadata (title, desc, progress)
          batch.insert(
            _db.coursesTable,
            CoursesTableCompanion.insert(
              id: _safeString(c['id']),
              slug: _safeString(c['slug']),
              title: _safeString(c['title']),
              description: Value(_safeString(c['description'])),
              level: _safeString(c['level']),
              trackType: _safeString(c['track_type']),
              thumbnailUrl: Value(_safeString(c['thumbnail_url'])),
              version: Value(remoteVersion),
              completedLessonsCount: Value(_safeInt(c['completed_count'])),
              totalLessonsCount: Value(_safeInt(c['total_lessons'])),
            ),
            mode: InsertMode.insertOrReplace,
          );
        }
      });

      if (coursesToSync.isEmpty) {
        debugPrint('All courses up to date.');
        return;
      }

      debugPrint('Syncing details for ${coursesToSync.length} courses...');

      // 3. Fetch details ONLY for outdated courses
      for (final courseId in coursesToSync) {
        try {
          final courseDetailResponse = await _api.get(
            '/api/courses/$courseId',
            queryParameters: {'userId': _userId},
          );
          final unitsData = courseDetailResponse.data['units'] as List;
          final assetsToDownload = <String>[];

          await _db.batch((batch) {
            for (final u in unitsData) {
              final unitId = _safeString(u['id']);
              // Insert Unit
              batch.insert(
                _db.unitsTable,
                UnitsTableCompanion.insert(
                  id: unitId,
                  courseId: _safeString(u['course_id']),
                  title: _safeString(u['title']),
                  orderIndex: _safeInt(u['order_index']),
                ),
                mode: InsertMode.insertOrReplace,
              );

              // Insert Lessons (Nested)
              if (u['lessons'] != null) {
                final lessonsData = u['lessons'] as List;
                for (final l in lessonsData) {
                  String? contentJsonStr;
                  final rawContent = l['content_json'];
                  if (rawContent != null) {
                    contentJsonStr = _safeString(rawContent);
                    // Extract assets for offline
                    assetsToDownload.addAll(
                      _syncService.extractAssetsFromContent(contentJsonStr),
                    );
                  }

                  batch.insert(
                    _db.lessonsTable,
                    LessonsTableCompanion.insert(
                      id: _safeString(l['id']),
                      unitId: unitId,
                      title: _safeString(l['title']),
                      contentType: _safeString(l['content_type']),
                      contentJson: Value(contentJsonStr),
                      orderIndex: _safeInt(l['order_index']),
                    ),
                    mode: InsertMode.insertOrReplace,
                  );
                }
              }
            }
          });

          // 4. Download Assets (Async)
          _syncService.downloadAssets(assetsToDownload);

          // 5. Sync Progress
          if (courseDetailResponse.data['completedLessonIds'] != null) {
            final completedIds = List<String>.from(
              courseDetailResponse.data['completedLessonIds'],
            );
            await _db.batch((batch) {
              for (final lessonId in completedIds) {
                batch.insert(
                  _db.localProgressTable,
                  LocalProgressTableCompanion.insert(
                    lessonId: lessonId,
                    isCompleted: const Value(true),
                    lastUpdated: Value(DateTime.now()),
                  ),
                  mode: InsertMode.insertOrReplace,
                );
              }
            });
          }
        } catch (e) {
          debugPrint('Error syncing course details for $courseId: $e');
        }
      }
    } catch (e) {
      debugPrint('Error syncing courses: $e');
    }
  }

  Future<void> fetchLessonDetails(String lessonId) async {
    try {
      final response = await _api.get('/api/lessons/$lessonId');
      final data = response.data;

      await (_db.update(
        _db.lessonsTable,
      )..where((t) => t.id.equals(lessonId))).write(
        LessonsTableCompanion(contentJson: Value(data['content_json'])),
      );
    } catch (e) {
      debugPrint('Error fetching lesson details: $e');
      rethrow;
    }
  }

  Future<void> saveLessonProgress({
    required String lessonId,
    required String courseId,
    required bool isCorrect,
    String interactionType = 'COMPLETION',
  }) async {
    if (_userId == null) return;

    final requestData = {
      'userId': _userId,
      'lessonId': lessonId,
      'courseId': courseId,
      'isCorrect': isCorrect,
      'interactionType': interactionType,
    };

    try {
      await _api.post('/api/progress', data: requestData);
      // Insert local progress immediately for optimistic UI
      await _db
          .into(_db.localProgressTable)
          .insert(
            LocalProgressTableCompanion.insert(
              lessonId: lessonId,
              isCompleted: const Value(true),
              lastUpdated: Value(DateTime.now()),
            ),
            mode: InsertMode.insertOrReplace,
          );
    } catch (e) {
      debugPrint('Network Error: $e. Queueing request.');
      // Queue for offline sync
      await _db
          .into(_db.pendingRequestsTable)
          .insert(
            PendingRequestsTableCompanion.insert(
              url: '/api/progress',
              method: 'POST',
              dataJson: jsonEncode(requestData),
            ),
          );
    }
  }

  Future<void> processPendingRequests() async {
    final pendingRequests = await _db.select(_db.pendingRequestsTable).get();
    if (pendingRequests.isEmpty) return;

    debugPrint('Processing ${pendingRequests.length} pending requests...');

    for (final req in pendingRequests) {
      try {
        final data = jsonDecode(req.dataJson);
        await _api.request(
          req.url,
          data: data,
          options: Options(method: req.method),
        );
        // If successful, delete from queue
        await (_db.delete(
          _db.pendingRequestsTable,
        )..where((tbl) => tbl.id.equals(req.id))).go();
        debugPrint('Synced request ${req.id}');
      } catch (e) {
        debugPrint('Failed to sync request ${req.id}: $e');
        // Leave in queue to retry later
      }
    }
  }
}

@riverpod
CourseRepository courseRepository(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  final api = ref.watch(apiClientProvider);
  final user = ref.watch(currentUserProvider);
  final syncService = ref.watch(contentSyncServiceProvider);
  return CourseRepository(db, api, user?.id, syncService);
}

// ... streams ...
@riverpod
Stream<List<Course>> courseList(Ref ref) {
  final repo = ref.watch(courseRepositoryProvider);
  return repo.watchCourses();
}

@riverpod
Stream<Course?> courseDetail(Ref ref, String id) {
  return ref.watch(courseRepositoryProvider).watchCourse(id);
}

@riverpod
Stream<List<Unit>> courseUnits(Ref ref, String courseId) {
  return ref.watch(courseRepositoryProvider).watchUnits(courseId);
}

@riverpod
Stream<List<Lesson>> unitLessons(Ref ref, String unitId) {
  return ref.watch(courseRepositoryProvider).watchLessons(unitId);
}

@riverpod
Stream<Lesson?> lessonDetail(Ref ref, String id) {
  return ref.watch(courseRepositoryProvider).watchLesson(id);
}
