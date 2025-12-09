import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/localization_helper.dart';
import '../../course_learning/data/course_repository.dart';
import '../../course_learning/data/course_downloader.dart';
import '../../course_learning/domain/unit.dart';
import '../../course_learning/domain/lesson.dart';

class CourseDetailScreen extends ConsumerStatefulWidget {
  final String courseId;

  const CourseDetailScreen({super.key, required this.courseId});

  @override
  ConsumerState<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends ConsumerState<CourseDetailScreen> {
  double? _downloadProgress;

  Future<void> _downloadCourse() async {
    setState(() {
      _downloadProgress = 0.0;
    });

    try {
      await ref
          .read(courseDownloaderProvider)
          .downloadCourse(
            widget.courseId,
            onProgress: (progress) {
              if (mounted) {
                setState(() {
                  _downloadProgress = progress;
                });
              }
            },
          );
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Download complete!')));
        setState(() {
          _downloadProgress = null; // Hide progress bar
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Download failed: $e')));
        setState(() {
          _downloadProgress = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final courseAsync = ref.watch(courseDetailProvider(widget.courseId));
    final unitsAsync = ref.watch(courseUnitsProvider(widget.courseId));

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context, courseAsync),
          unitsAsync.when(
            data: (units) => SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final unit = units[index];
                return UnitSection(unit: unit, courseId: widget.courseId);
              }, childCount: units.length),
            ),
            loading: () => SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 150,
                        height: 20,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 100,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ],
                  ),
                ),
                childCount: 3,
              ),
            ),
            error: (err, stack) => SliverFillRemaining(
              child: Center(child: Text('Error loading units: $err')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(
    BuildContext context,
    AsyncValue<dynamic> courseAsync,
  ) {
    return SliverAppBar.large(
      expandedHeight: 200,
      pinned: true,
      actions: [
        if (_downloadProgress != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  value: _downloadProgress,
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              ),
            ),
          )
        else
          IconButton(
            icon: const Icon(Icons.download_for_offline_outlined),
            tooltip: 'Download Course',
            onPressed: _downloadCourse,
          ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        title: courseAsync.when(
          data: (course) => Text(
            getLocalized(context, course?.title) ?? 'Course Not Found',
            style: const TextStyle(fontSize: 16),
          ),
          loading: () => const Text('Loading...'),
          error: (_, __) => const Text('Error'),
        ),
        background: courseAsync.when(
          data: (course) {
            final isSpecialized = course?.trackType == 'SPECIALIZED';
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isSpecialized
                      ? [Colors.orange.shade300, Colors.deepOrange.shade400]
                      : [Colors.blue.shade300, Colors.indigo.shade400],
                ),
              ),
              child: Center(
                child: Hero(
                  tag: 'course_thumb_${widget.courseId}',
                  child: Icon(
                    isSpecialized ? Icons.engineering : Icons.language,
                    size: 64,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
          loading: () => Container(color: Colors.grey.shade200),
          error: (_, __) => Container(color: Colors.red.shade100),
        ),
      ),
    );
  }
}

class UnitSection extends ConsumerWidget {
  final Unit unit;
  final String courseId;

  const UnitSection({super.key, required this.unit, required this.courseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonsAsync = ref.watch(unitLessonsProvider(unit.id));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              getLocalized(context, unit.title),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          lessonsAsync.when(
            data: (lessons) => Card(
              elevation: 0,
              color: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              child: Column(
                children: lessons
                    .map(
                      (lesson) =>
                          _LessonTile(lesson: lesson, courseId: courseId),
                    )
                    .toList(),
              ),
            ),
            loading: () => const LinearProgressIndicator(),
            error: (err, _) => Text('Error: $err'),
          ),
        ],
      ),
    );
  }
}

class _LessonTile extends StatelessWidget {
  final Lesson lesson;
  final String courseId;

  const _LessonTile({required this.lesson, required this.courseId});

  IconData _getIconForType(String type) {
    switch (type) {
      case 'AUDIO_DRILL':
        return Icons.headphones;
      case 'DIALOGUE':
        return Icons.chat_bubble_outline;
      case 'QUIZ':
        return Icons.quiz;
      default:
        return Icons.article;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: Icon(_getIconForType(lesson.contentType), size: 20),
      ),
      title: Text(getLocalized(context, lesson.title)),
      trailing: lesson.isCompleted
          ? const Icon(Icons.check_circle, color: Colors.green)
          : const Icon(Icons.chevron_right),
      onTap: () {
        context.go('/course/$courseId/lesson/${lesson.id}');
      },
    );
  }
}
