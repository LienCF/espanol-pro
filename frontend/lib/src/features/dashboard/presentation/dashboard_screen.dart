import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/auth/auth_repository.dart';
import '../../course_learning/data/course_repository.dart';
import '../../course_learning/domain/course.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Sync data from backend on init
    ref.read(courseRepositoryProvider).syncCourses();
    // Retry any failed offline requests
    ref.read(courseRepositoryProvider).processPendingRequests();
  }

  @override
  Widget build(BuildContext context) {
    final coursesAsync = ref.watch(courseListProvider);
    final user = ref.watch(currentUserProvider);
    final isPremium = user?.isPremium ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Español Pro'),
        centerTitle: false,
        actions: [
          if (!isPremium)
            TextButton.icon(
              onPressed: () => context.push('/paywall'),
              icon: const Icon(Icons.diamond, color: Colors.orange),
              label: const Text('Go Pro', style: TextStyle(color: Colors.orange)),
            ),
          PopupMenuButton(
            icon: const Icon(Icons.person_outline),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Logout'),
                onTap: () {
                  ref.read(authRepositoryProvider).logout();
                },
              ),
            ],
          ),
        ],
      ),
      body: coursesAsync.when(
        data: (courses) => _buildCourseList(context, courses, isPremium),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildCourseList(BuildContext context, List<Course> courses, bool isPremium) {
    if (courses.isEmpty) {
      return const Center(child: Text('No courses available yet.'));
    }

    // Split courses by track
    final generalTrack = courses.where((c) => c.trackType == 'GENERAL').toList();
    final specializedTrack = courses.where((c) => c.trackType == 'SPECIALIZED').toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (generalTrack.isNotEmpty) ...[
          _buildSectionHeader(context, 'General Proficiency', Icons.school),
          const SizedBox(height: 8),
          ...generalTrack.map((c) => CourseCard(course: c, isLocked: false)), // General is always free for MVP
          const SizedBox(height: 24),
        ],
        if (specializedTrack.isNotEmpty) ...[
          _buildSectionHeader(context, 'Specialized Tracks (ESP)', Icons.work),
          const SizedBox(height: 8),
          ...specializedTrack.map((c) => CourseCard(course: c, isLocked: !isPremium)),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}

class CourseCard extends StatelessWidget {
  final Course course;
  final bool isLocked;

  const CourseCard({super.key, required this.course, required this.isLocked});

  @override
  Widget build(BuildContext context) {
    final isSpecialized = course.trackType == 'SPECIALIZED';
    final colorScheme = Theme.of(context).colorScheme;
    
    return Card(
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.2),
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          if (isLocked) {
            context.push('/paywall');
          } else {
            context.go('/course/${course.id}');
          }
        },
        child: Stack(
          children: [
            Row(
              children: [
                // Thumbnail
                Hero(
                  tag: 'course_thumb_${course.id}',
                  child: Container(
                    width: 100,
                    height: 110,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isSpecialized 
                            ? [Colors.orange.shade300, Colors.deepOrange.shade400]
                            : [Colors.blue.shade300, Colors.indigo.shade400],
                      ),
                    ),
                    child: Icon(
                      isSpecialized ? Icons.engineering : Icons.language,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                course.title,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isLocked)
                              const Icon(Icons.lock, size: 16, color: Colors.grey)
                            else
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isSpecialized 
                                      ? colorScheme.tertiaryContainer 
                                      : colorScheme.secondaryContainer,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  course.level,
                                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: isSpecialized 
                                            ? colorScheme.onTertiaryContainer 
                                            : colorScheme.onSecondaryContainer,
                                      ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          course.description ?? '',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (course.completedLessonsCount > 0) ...[
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              minHeight: 6,
                              value: course.totalLessonsCount > 0 
                                  ? course.completedLessonsCount / course.totalLessonsCount 
                                  : 0.0,
                              backgroundColor: colorScheme.surfaceContainerHighest,
                              color: isSpecialized ? Colors.orange : colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${course.completedLessonsCount} / ${course.totalLessonsCount} lessons completed',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: colorScheme.onSurfaceVariant
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (isLocked)
              Positioned.fill(
                child: Container(
                  color: Colors.white.withOpacity(0.5), // Fade effect
                ),
              ),
          ],
        ),
      ),
    );
  }
}
