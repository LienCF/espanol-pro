import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../core/auth/auth_repository.dart';
import '../../../core/auth/app_user.dart';
import '../../../core/utils/localization_helper.dart';
import '../../course_learning/data/course_repository.dart';
import '../../course_learning/data/skills_repository.dart';
import '../../course_learning/domain/course.dart';
import '../../course_learning/domain/skill.dart';

import '../../gamification/presentation/leaderboard_screen.dart';

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
    ref.read(courseRepositoryProvider).syncCourses();
    ref.read(courseRepositoryProvider).processPendingRequests();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final isPremium = user?.isPremium ?? false;
    final l10n = AppLocalizations.of(context)!;

    Widget body;
    if (_selectedIndex == 0) {
      body = _buildCoursesTab(isPremium, l10n, user);
    } else if (_selectedIndex == 1) {
      body = _buildSkillsTab(l10n);
    } else {
      body = const LeaderboardScreen();
    }

    return Scaffold(
      body: body,
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
          NavigationDestination(
            icon: const Icon(Icons.emoji_events_outlined),
            selectedIcon: const Icon(Icons.emoji_events),
            label: l10n.leaderboardTab,
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesTab(
    bool isPremium,
    AppLocalizations l10n,
    AppUser? user,
  ) {
    final coursesAsync = ref.watch(courseListProvider);

    return coursesAsync.when(
      data: (courses) =>
          _buildCourseList(context, courses, isPremium, l10n, user),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) =>
          Center(child: Text(l10n.errorWithMsg(err.toString()))),
    );
  }

  Widget _buildSkillsTab(AppLocalizations l10n) {
    final skillsAsync = ref.watch(userSkillsProvider);

    return CustomScrollView(
      slivers: [
        SliverAppBar.large(title: Text(l10n.skillsTab), centerTitle: false),
        skillsAsync.when(
          data: (skills) {
            if (skills.isEmpty) {
              return SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.psychology_outlined,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.noSkillsData,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Text(
                        l10n.trackMasteryHint,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            }
            return SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final skill = skills[index];
                  return SkillCard(skill: skill);
                }, childCount: skills.length),
              ),
            );
          },
          loading: () => const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (err, stack) => SliverFillRemaining(
            child: Center(child: Text(l10n.errorWithMsg(err.toString()))),
          ),
        ),
      ],
    );
  }

  Widget _buildCourseList(
    BuildContext context,
    List<Course> courses,
    bool isPremium,
    AppLocalizations l10n,
    AppUser? user,
  ) {
    final generalTrack = courses
        .where((c) => c.trackType == 'GENERAL')
        .toList();
    final specializedTrack = courses
        .where((c) => c.trackType == 'SPECIALIZED')
        .toList();

    return CustomScrollView(
      slivers: [
        SliverAppBar.large(
          title: Text(l10n.appTitle),
          centerTitle: false,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.local_fire_department,
                    color: Colors.orangeAccent,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${user?.currentStreak ?? 0}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    '${user?.totalXp ?? 0}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            if (!isPremium)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: TextButton.icon(
                  onPressed: () => context.push('/paywall'),
                  icon: const Icon(Icons.diamond, color: Colors.orange),
                  label: Text(
                    l10n.goPro,
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.orange.withValues(alpha: 0.1),
                  ),
                ),
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
        if (courses.isEmpty)
          SliverFillRemaining(
            child: Center(child: Text(l10n.noCoursesAvailable)),
          ),

        if (generalTrack.isNotEmpty) ...[
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            sliver: SliverToBoxAdapter(
              child: _buildSectionHeader(
                context,
                l10n.generalProficiency,
                Icons.school,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: _buildResponsiveGrid(generalTrack, false),
          ),
        ],

        if (specializedTrack.isNotEmpty) ...[
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 8),
            sliver: SliverToBoxAdapter(
              child: _buildSectionHeader(
                context,
                l10n.specializedTracks,
                Icons.work,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: _buildResponsiveGrid(specializedTrack, !isPremium),
          ),
        ],

        const SliverPadding(padding: EdgeInsets.only(bottom: 32)),
      ],
    );
  }

  Widget _buildResponsiveGrid(List<Course> courses, bool isLocked) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.crossAxisExtent;
        int crossAxisCount = 1;
        double childAspectRatio = 1.5; // Default for mobile

        if (width > 1200) {
          crossAxisCount = 3;
          childAspectRatio = 1.4;
        } else if (width > 700) {
          crossAxisCount = 2;
          childAspectRatio = 1.6;
        } else if (width > 500) {
          crossAxisCount = 1; // Tablet portrait or large phone
          childAspectRatio = 2.5; // Wide card
        }

        return SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: childAspectRatio,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) =>
                CourseCard(course: courses[index], isLocked: isLocked),
            childCount: courses.length,
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary, size: 28),
        const SizedBox(width: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface,
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
      elevation: 0,
      color: colorScheme.surfaceContainer,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: skill.masteryLevel),
                    duration: const Duration(milliseconds: 1500),
                    curve: Curves.easeOutQuart,
                    builder: (context, value, _) {
                      return CircularProgressIndicator(
                        value: value,
                        strokeWidth: 8,
                        backgroundColor: colorScheme.surfaceContainerHigh,
                        color: progressColor,
                        strokeCap: StrokeCap.round,
                      );
                    },
                  ),
                  Center(
                    child: TweenAnimationBuilder<int>(
                      tween: IntTween(begin: 0, end: masteryPercent),
                      duration: const Duration(milliseconds: 1500),
                      curve: Curves.easeOutQuart,
                      builder: (context, value, _) {
                        return Text(
                          '$value%',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getLocalized(context, skill.name),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (skill.description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      getLocalized(context, skill.description),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
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
      elevation: 2, // Softer shadow
      margin: EdgeInsets.zero, // Grid handles spacing
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
                // Modern Thumbnail
                Container(
                  width: 120,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isSpecialized
                          ? [Colors.orange.shade400, Colors.deepOrange.shade600]
                          : [Colors.blue.shade400, Colors.indigo.shade600],
                    ),
                  ),
                  child: Center(
                    child: Hero(
                      tag: 'course_icon_${course.id}',
                      child: Icon(
                        isSpecialized ? Icons.engineering : Icons.language,
                        size: 48,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                getLocalized(context, course.title),
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      height: 1.2,
                                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (isLocked)
                              const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Icon(
                                  Icons.lock_outline,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isSpecialized
                                ? colorScheme.tertiaryContainer
                                : colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            course.level,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isSpecialized
                                      ? colorScheme.onTertiaryContainer
                                      : colorScheme.onSecondaryContainer,
                                ),
                          ),
                        ),
                        const Spacer(),
                        if (course.completedLessonsCount > 0) ...[
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: TweenAnimationBuilder<double>(
                              tween: Tween<double>(
                                begin: 0,
                                end: course.totalLessonsCount > 0
                                    ? course.completedLessonsCount /
                                          course.totalLessonsCount
                                    : 0.0,
                              ),
                              duration: const Duration(milliseconds: 1000),
                              curve: Curves.easeOutCubic,
                              builder: (context, value, _) {
                                return LinearProgressIndicator(
                                  minHeight: 6,
                                  value: value,
                                  backgroundColor:
                                      colorScheme.surfaceContainerHighest,
                                  color: isSpecialized
                                      ? Colors.orange
                                      : colorScheme.primary,
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            l10n.lessonsCompleted(
                              course.completedLessonsCount,
                              course.totalLessonsCount,
                            ),
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                        ] else
                          Text(
                            getLocalized(context, course.description),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: colorScheme.onSurfaceVariant),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (isLocked)
              Positioned.fill(
                child: Container(
                  color: Colors.white.withValues(alpha: 0.6),
                  child: const Center(
                    child: Icon(Icons.lock, size: 48, color: Colors.black26),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
