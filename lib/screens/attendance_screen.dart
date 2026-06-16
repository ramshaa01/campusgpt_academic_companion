import 'package:flutter/material.dart';
import '../theme.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 64, 16, 120),
      children: [
        // Header
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
        
        // Summary Card
        GlassCard(
          child: Column(
            children: [
              Text(
                'Overall Attendance',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '84.5',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: CampusGptTheme.primary,
                    ),
                  ),
                  Text(
                    '%',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: CampusGptTheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Text(
                  'SAFE (Target: 75%)',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.greenAccent,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        
        // Subject List
        Text(
          'YOUR SUBJECTS',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.5),
        ),
        const SizedBox(height: 16),
        _buildSubjectCard(context, 'Mathematics III', 88.8, 32, 36, true),
        const SizedBox(height: 12),
        _buildSubjectCard(context, 'Physics - Quantum', 71.4, 25, 35, false),
        const SizedBox(height: 12),
        _buildSubjectCard(context, 'Computer Science', 85.3, 29, 34, true),
      ],
    );
  }

  Widget _buildSubjectCard(
      BuildContext context, String title, double percentage, int attended, int total, bool isSafe) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: CampusGptTheme.onSurface,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isSafe ? Colors.green.withOpacity(0.1) : CampusGptTheme.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: isSafe ? Colors.green.withOpacity(0.3) : CampusGptTheme.error.withOpacity(0.3),
                  ),
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
                    '$percentage%',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    '$attended/$total Classes',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
              Row(
                children: [
                  _buildActionButton(context, Icons.close, CampusGptTheme.error),
                  const SizedBox(width: 8),
                  _buildActionButton(context, Icons.check, Colors.greenAccent),
                ],
              ),
            ],
          ),
          if (!isSafe) ...[
            const SizedBox(height: 16),
            Text(
              '⚠️ Attend next 3 classes to reach 75%',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: CampusGptTheme.error,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, Color color) {
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
        onPressed: () {},
      ),
    );
  }
}
