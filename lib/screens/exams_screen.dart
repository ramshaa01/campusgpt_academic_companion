import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme.dart';

class ExamsScreen extends StatelessWidget {
  const ExamsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final exams = context.watch<AppState>().exams;

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 64, 16, 32),
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Text(
                  'Upcoming Exams',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: 24,
                        color: CampusGptTheme.onSurface,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...exams.map((exam) {
            final days = exam.date.difference(DateTime.now()).inDays.clamp(0, 999);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GlassCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: CampusGptTheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            days.toString().padLeft(2, '0'),
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontSize: 18,
                                  color: CampusGptTheme.primary,
                                ),
                          ),
                          Text(
                            'Days',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 8),
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
                            exam.title,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: CampusGptTheme.onSurface,
                                ),
                          ),
                          Text(exam.subtitle, style: Theme.of(context).textTheme.bodySmall),
                          Text(
                            _formatDate(exam.date),
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: CampusGptTheme.secondary,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
