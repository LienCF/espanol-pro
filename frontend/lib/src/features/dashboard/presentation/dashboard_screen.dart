import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../core/auth/auth_repository.dart';
import '../../../core/utils/localization_helper.dart';
import '../../course_learning/data/course_repository.dart';
import '../../course_learning/data/skills_repository.dart';
import '../../course_learning/domain/course.dart';
import '../../course_learning/domain/skill.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _selectedIndex = 0;

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
    final user = ref.watch(currentUserProvider);
    final isPremium = user?.isPremium ?? false;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        centerTitle: false,
        actions: [
          if (!isPremium)
            TextButton.icon(
              onPressed: () => context.push('/paywall'),
              icon: const Icon(Icons.diamond, color: Colors.orange),
              label: Text(l10n.goPro, style: const TextStyle(color: Colors.orange)),
            ),
          PopupMenuButton(
            icon: const Icon(Icons.person_outline),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text(l10n.logout),
                onTap: () {
                  ref.read(authRepositoryProvider).logout();
                },
              ),
            ],
          ),
        ],
      ),
      body: _selectedIndex == 0 
          ? _buildCoursesTab(isPremium)
          : _buildSkillsTab(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard),
            label: l10n.coursesTab,
          ),
          NavigationDestination(
            icon: const Icon(Icons.insights_outlined),
            selectedIcon: const Icon(Icons.insights),
            label: l10n.skillsTab,
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesTab(bool isPremium) {
    final coursesAsync = ref.watch(courseListProvider);
    
    return coursesAsync.when(
      data: (courses) => _buildCourseList(context, courses, isPremium),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text(AppLocalizations.of(context)!.errorWithMsg(err.toString()))),
    );
  }

  Widget _buildSkillsTab() {
    final skillsAsync = ref.watch(userSkillsProvider);
    final l10n = AppLocalizations.of(context)!;

    return skillsAsync.when(
      data: (skills) {
        if (skills.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.psychology_outlined, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(l10n.noSkillsData, style: const TextStyle(color: Colors.grey)),
                Text(l10n.trackMasteryHint, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: skills.length,
          itemBuilder: (context, index) {
            final skill = skills[index];
            return SkillCard(skill: skill);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text(l10n.errorWithMsg(err.toString()))),
    );
  }

  Widget _buildCourseList(BuildContext context, List<Course> courses, bool isPremium) {
    final l10n = AppLocalizations.of(context)!;
    if (courses.isEmpty) {
      return Center(child: Text(l10n.noCoursesAvailable));
    }
    
    // Split courses by track
    final generalTrack = courses.where((c) => c.trackType == 'GENERAL').toList();
    final specializedTrack = courses.where((c) => c.trackType == 'SPECIALIZED').toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          // Desktop / Tablet Grid Layout
          return Padding(
            padding: const EdgeInsets.all(24),
            child: CustomScrollView(
              slivers: [
                if (generalTrack.isNotEmpty) ...[
                  SliverToBoxAdapter(child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _buildSectionHeader(context, l10n.generalProficiency, Icons.school),
                  )),
                  SliverGrid(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 400,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.8,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => CourseCard(course: generalTrack[index], isLocked: false),
                      childCount: generalTrack.length,
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 32)),
                ],
                if (specializedTrack.isNotEmpty) ...[
                  SliverToBoxAdapter(child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _buildSectionHeader(context, l10n.specializedTracks, Icons.work),
                  )),
                  SliverGrid(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 400,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.8,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => CourseCard(course: specializedTrack[index], isLocked: !isPremium),
                      childCount: specializedTrack.length,
                    ),
                  ),
                ],
              ],
            ),
          );
        } else {
          // Mobile List Layout
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (generalTrack.isNotEmpty) ...[
                _buildSectionHeader(context, l10n.generalProficiency, Icons.school),
                const SizedBox(height: 8),
                ...generalTrack.map((c) => CourseCard(course: c, isLocked: false)), // General is always free for MVP
                const SizedBox(height: 24),
              ],
              if (specializedTrack.isNotEmpty) ...[
                _buildSectionHeader(context, l10n.specializedTracks, Icons.work),
                const SizedBox(height: 8),
                ...specializedTrack.map((c) => CourseCard(course: c, isLocked: !isPremium)),
              ],
            ],
          );
        }
      },
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

class SkillCard extends StatelessWidget {
  final Skill skill;

  const SkillCard({super.key, required this.skill});

  @override
  Widget build(BuildContext context) {
    final masteryPercent = (skill.masteryLevel * 100).toInt();
    final colorScheme = Theme.of(context).colorScheme;

    Color progressColor;
    if (skill.masteryLevel < 0.4) {
      progressColor = Colors.red;
    } else if (skill.masteryLevel < 0.8) {
      progressColor = Colors.orange;
    } else {
      progressColor = Colors.green;
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: skill.masteryLevel,
                    strokeWidth: 6,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    color: progressColor,
                  ),
                  Center(
                    child: Text(
                      '$masteryPercent%',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    skill.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  if (skill.description != null)
                    Text(
                      skill.description!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
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
    final l10n = AppLocalizations.of(context)!;
    
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
                                getLocalized(context, course.title),
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
                          getLocalized(context, course.description),
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
                            l10n.lessonsCompleted(course.completedLessonsCount, course.totalLessonsCount),
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