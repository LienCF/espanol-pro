import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/auth/auth_repository.dart';
import '../../analytics/data/analytics_repository.dart';
import '../../course_learning/data/course_repository.dart';
import '../data/admin_repository.dart';
import 'course_editor_dialog.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Basic Auth Check (In real app, check role)
    final user = ref.watch(currentUserProvider);
    if (user == null) {
      return const Scaffold(body: Center(child: Text('Unauthorized')));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              if (_selectedIndex == 0) {
                ref.read(courseRepositoryProvider).syncCourses();
              }
              // Refresh analytics if on that tab (not implemented yet for repo stream)
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authRepositoryProvider).logout(),
          ),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() => _selectedIndex = index);
            },
            labelType: NavigationRailLabelType.all,
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.book),
                label: Text('Courses'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.analytics),
                label: Text('Analytics'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: _selectedIndex == 0 ? _AdminCourseList() : _AnalyticsView(),
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  heroTag: 'ai_gen',
                  onPressed: () async {
                    final controller = TextEditingController();
                    final topic = await showDialog<String>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Generate AI Lesson'),
                        content: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            labelText: 'Topic (e.g. "Ordering Coffee")',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            onPressed: () =>
                                Navigator.pop(context, controller.text),
                            child: const Text('Generate'),
                          ),
                        ],
                      ),
                    );

                    if (topic != null && topic.isNotEmpty) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Generating lesson... please wait.'),
                          ),
                        );
                      }
                      try {
                        final result = await ref
                            .read(adminRepositoryProvider)
                            .generateLesson(topic, 'A1');
                        // In a real app, we would now save this as a new Course/Lesson
                        // For prototype, just show the result
                        if (context.mounted) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(result['title']),
                              content: SingleChildScrollView(
                                child: Text(result['content_json']),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Close'),
                                ),
                              ],
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Generation failed: $e')),
                          );
                        }
                      }
                    }
                  },
                  child: const Icon(Icons.auto_awesome),
                ),
                const SizedBox(width: 16),
                FloatingActionButton(
                  heroTag: 'add_course',
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) => const CourseEditorDialog(),
                    );
                    ref.read(courseRepositoryProvider).syncCourses();
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            )
          : null,
    );
  }
}

class _AnalyticsView extends ConsumerStatefulWidget {
  @override
  ConsumerState<_AnalyticsView> createState() => _AnalyticsViewState();
}

class _AnalyticsViewState extends ConsumerState<_AnalyticsView> {
  List<Map<String, dynamic>> _stats = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final stats = await ref.read(analyticsRepositoryProvider).getStats();
    if (mounted) {
      setState(() {
        _stats = stats;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_stats.isEmpty) {
      return const Center(child: Text('No events recorded yet.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _stats.length,
      itemBuilder: (context, index) {
        final item = _stats[index];
        return Card(
          child: ListTile(
            leading: const Icon(Icons.event),
            title: Text(item['event_name'] ?? 'Unknown'),
            trailing: Text(
              '${item['count']}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
        );
      },
    );
  }
}

class _AdminCourseList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(courseListProvider);

    return coursesAsync.when(
      data: (courses) => ListView.builder(
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return ListTile(
            title: Text(course.title), // Show Raw JSON for admin or parse it
            subtitle: Text('${course.id} • ${course.level}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (context) => CourseEditorDialog(course: course),
                    );
                    ref.read(courseRepositoryProvider).syncCourses();
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Course?'),
                        content: const Text('This cannot be undone.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      await ref
                          .read(adminRepositoryProvider)
                          .deleteCourse(course.id);
                      ref.read(courseRepositoryProvider).syncCourses();
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
