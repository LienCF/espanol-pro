import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../course_learning/data/course_repository.dart';
import '../../course_learning/domain/unit.dart';
import '../../course_learning/domain/lesson.dart';

class CourseDetailScreen extends ConsumerWidget {
  final String courseId;

  const CourseDetailScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseAsync = ref.watch(courseDetailProvider(courseId));
    final unitsAsync = ref.watch(courseUnitsProvider(courseId));

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context, courseAsync),
          unitsAsync.when(
            data: (units) => SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final unit = units[index];
                  return UnitSection(unit: unit, courseId: courseId);
                },
                childCount: units.length,
              ),
            ),
            loading: () => const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, stack) => SliverFillRemaining(
              child: Center(child: Text('Error loading units: $err')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, AsyncValue<dynamic> courseAsync) {
    return SliverAppBar.large(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: courseAsync.when(
          data: (course) => Text(course?.title ?? 'Course Not Found', 
              style: const TextStyle(fontSize: 16)), // Keep title small in collapsed state
          loading: () => const Text('Loading...'),
          error: (_, __) => const Text('Error'),
        ),
        background: Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Center(
            child: Icon(Icons.school, size: 64, color: Theme.of(context).colorScheme.onPrimaryContainer),
          ),
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
              unit.title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
          lessonsAsync.when(
            data: (lessons) => Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
              ),
              child: Column(
                children: lessons.map((lesson) => _LessonTile(lesson: lesson, courseId: courseId)).toList(),
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
      title: Text(lesson.title),
      trailing: lesson.isCompleted 
          ? const Icon(Icons.check_circle, color: Colors.green)
          : const Icon(Icons.chevron_right),
      onTap: () {
        context.go('/course/$courseId/lesson/${lesson.id}');
      },
    );
  }
}
