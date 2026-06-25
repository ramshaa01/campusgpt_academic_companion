import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/user_avatar.dart';
import 'attendance_screen.dart';
import 'assistant_screen.dart';
import 'exams_screen.dart';
import 'gpa_screen.dart';
import 'notes_screen.dart';
import 'pyq_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final user = appState.user!;
    final attendance = appState.overallAttendance;
    final aiScore = appState.aiScore;
    final notesCount = appState.notes.length;
    final isSafe = attendance >= 75;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 64, 16, 120),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            UserAvatar(name: user.name, radius: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'CampusGPT',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: CampusGptTheme.primaryContainer,
                      fontSize: 24,
                    ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: CampusGptTheme.primaryContainer.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: CampusGptTheme.primary.withOpacity(0.2)),
              ),
              child: Text(
                'Streak ${appState.streakDays}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: CampusGptTheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.logout, size: 20),
              tooltip: 'Sign out',
              onPressed: () => appState.signOut(),
            ),
          ],
        ),
        const SizedBox(height: 32),
        GlassCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back, ${user.name}.',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: CampusGptTheme.primaryContainer,
                                fontSize: 20,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Ready to optimize your semester?',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'AI SCORE',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: CampusGptTheme.secondaryContainer,
                            ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          GradientText(
                            '$aiScore',
                            gradient: const LinearGradient(
                              colors: [CampusGptTheme.primary, CampusGptTheme.secondary],
                            ),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                              height: 1.2,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '/100',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: CampusGptTheme.onSurfaceVariant.withOpacity(0.7),
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Daily Progress',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: CampusGptTheme.onSurfaceVariant.withOpacity(0.7),
                        ),
                  ),
                  Text(
                    '${(aiScore * 0.82).round()}%',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: CampusGptTheme.onSurfaceVariant.withOpacity(0.7),
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: CampusGptTheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: FractionallySizedBox(
                  widthFactor: (aiScore / 100).clamp(0.05, 1.0),
                  alignment: Alignment.centerLeft,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [CampusGptTheme.primaryContainer, CampusGptTheme.secondaryContainer],
                      ),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: GlassCard(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AttendanceScreen()),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.fact_check, color: CampusGptTheme.secondaryContainer),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: (isSafe ? Colors.green : CampusGptTheme.error).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            isSafe ? 'SAFE' : 'WARN',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: isSafe ? Colors.greenAccent : CampusGptTheme.error,
                                  fontSize: 10,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text('ATTENDANCE', style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10)),
                    const SizedBox(height: 4),
                    Text(
                      '${attendance.toStringAsFixed(1)}%',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GlassCard(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotesScreen()),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.auto_awesome, color: CampusGptTheme.primary),
                    const SizedBox(height: 16),
                    Text('NOTES GEN', style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10)),
                    const SizedBox(height: 4),
                    Text(
                      '${notesCount.toString().padLeft(2, '0')} Notes',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: GlassCard(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PyqScreen()),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.analytics, color: CampusGptTheme.tertiary),
                    const SizedBox(height: 16),
                    Text('PYQ ANALYZER', style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10)),
                    const SizedBox(height: 4),
                    const Text(
                      '6 Trends',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GlassCard(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AssistantScreen()),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.psychology, color: CampusGptTheme.secondary),
                    const SizedBox(height: 16),
                    Text('AI TUTOR', style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10)),
                    const SizedBox(height: 4),
                    Text(
                      appState.isOnline ? 'Online' : 'Offline',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GlassCard(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const GpaScreen()),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.calculate, color: CampusGptTheme.secondary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'GPA Predictor',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Target ${appState.targetGpa.toStringAsFixed(1)} • Current ${appState.currentCgpa.toStringAsFixed(1)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'UPCOMING EXAMS',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.5),
            ),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ExamsScreen()),
              ),
              child: Text(
                'View All',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: CampusGptTheme.secondary,
                      fontSize: 10,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...appState.exams.take(2).map((exam) {
          final days = exam.date.difference(DateTime.now()).inDays.clamp(0, 99);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildExamCard(
              context,
              days.toString().padLeft(2, '0'),
              exam.title,
              exam.subtitle,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildExamCard(BuildContext context, String days, String title, String subtitle) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: CampusGptTheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: CampusGptTheme.onSurface.withOpacity(0.1)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  days,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 18,
                        height: 1.0,
                        color: CampusGptTheme.primary,
                      ),
                ),
                Text('Days', style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 8)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: CampusGptTheme.onSurface,
                      ),
                ),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: CampusGptTheme.onSurfaceVariant.withOpacity(0.5)),
        ],
      ),
    );
  }
}
