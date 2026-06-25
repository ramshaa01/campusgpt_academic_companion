import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_models.dart';
import '../state/app_state.dart';
import '../theme.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final subjects = appState.subjects;
    final overall = appState.overallAttendance;
    final isSafe = overall >= 75;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 64, 16, 120),
      children: [
        Row(
          children: [
            if (Navigator.of(context).canPop())
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
            Expanded(
              child: Text(
                'Attendance Tracker',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontSize: 24,
                      color: CampusGptTheme.onSurface,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        GlassCard(
          child: Column(
            children: [
              Text('Overall Attendance', style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    overall.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: isSafe ? CampusGptTheme.primary : CampusGptTheme.error,
                        ),
                  ),
                  Text(
                    '%',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: isSafe ? CampusGptTheme.primary : CampusGptTheme.error,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: (isSafe ? Colors.green : CampusGptTheme.error).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  isSafe ? 'SAFE (Target: 75%)' : 'WARNING (Target: 75%)',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isSafe ? Colors.greenAccent : CampusGptTheme.error,
                      ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'YOUR SUBJECTS',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.5),
        ),
        const SizedBox(height: 16),
        ...List.generate(subjects.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _SubjectCard(
              subject: subjects[index],
              onMark: (present) => appState.markAttendance(index, present),
            ),
          );
        }),
      ],
    );
  }
}

class _SubjectCard extends StatelessWidget {
  const _SubjectCard({required this.subject, required this.onMark});

  final SubjectAttendance subject;
  final void Function(bool present) onMark;

  @override
  Widget build(BuildContext context) {
    final isSafe = subject.isSafe;

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  subject.title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: CampusGptTheme.onSurface,
                      ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: (isSafe ? Colors.green : CampusGptTheme.error).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  isSafe ? 'SAFE' : 'WARNING',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isSafe ? Colors.greenAccent : CampusGptTheme.error,
                        fontSize: 10,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${subject.percentage.toStringAsFixed(1)}%',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    '${subject.attended}/${subject.total} Classes',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
              Row(
                children: [
                  _actionButton(Icons.close, CampusGptTheme.error, () {
                    onMark(false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Marked Absent'), duration: Duration(seconds: 1)),
                    );
                  }),
                  const SizedBox(width: 8),
                  _actionButton(Icons.check, Colors.greenAccent, () {
                    onMark(true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Marked Present'), duration: Duration(seconds: 1)),
                    );
                  }),
                ],
              ),
            ],
          ),
          if (!isSafe) ...[
            const SizedBox(height: 16),
            Text(
              'Attend next ${subject.classesToReachSafe()} classes to reach 75%',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(color: CampusGptTheme.error),
            ),
          ],
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, Color color, VoidCallback onPressed) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: IconButton(
        icon: Icon(icon, color: color, size: 20),
        onPressed: onPressed,
      ),
    );
  }
}
