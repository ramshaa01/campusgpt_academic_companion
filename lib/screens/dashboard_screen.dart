import 'package:flutter/material.dart';
import '../theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 64, 16, 120),
      children: [
        // Welcome Header
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: CampusGptTheme.primary.withOpacity(0.3)),
                image: const DecorationImage(
                  image: NetworkImage('https://i.pravatar.cc/150?img=11'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
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
                '🔥 12',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: CampusGptTheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        
        // Welcome Card
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
                          'Welcome back, Alex.',
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
                            '88',
                            gradient: const LinearGradient(
                              colors: [CampusGptTheme.primary, CampusGptTheme.secondary],
                            ),
                            style: Theme.of(context).textTheme.displayMedium,
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
                    '72%',
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
                  widthFactor: 0.72,
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
        
        // Bento Grid
        Row(
          children: [
            Expanded(
              child: GlassCard(
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
                            color: Colors.green.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.green.withOpacity(0.3)),
                          ),
                          child: Text(
                            'SAFE',
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.greenAccent,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'ATTENDANCE',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '84.5%',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GlassCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.auto_awesome, color: CampusGptTheme.primary),
                    const SizedBox(height: 16),
                    Text(
                      'NOTES GEN',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Draft 04',
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.analytics, color: CampusGptTheme.tertiary),
                    const SizedBox(height: 16),
                    Text(
                      'PYQ ANALYZER',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '6 Trends',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GlassCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.psychology, color: CampusGptTheme.secondary),
                    const SizedBox(height: 16),
                    Text(
                      'AI TUTOR',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Online',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        // Upcoming Exams
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'UPCOMING EXAMS',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.5),
            ),
            Text(
              'View All',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: CampusGptTheme.secondary,
                fontSize: 10,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildExamCard(context, '03', 'Advanced Thermodynamics', 'Final Assessment • Hall 4B'),
        const SizedBox(height: 12),
        _buildExamCard(context, '08', 'Data Structures & Algos', 'Midterm • LT-12'),
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
                Text(
                  'Days',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontSize: 8,
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
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: CampusGptTheme.onSurface,
                  ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right,
            color: CampusGptTheme.onSurfaceVariant.withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}
