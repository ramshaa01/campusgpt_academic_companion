import 'package:flutter/material.dart';
import '../theme.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 64, 16, 120),
      children: [
        // Header
        Row(
          children: [
            Expanded(
              child: Text(
                'AI Notes Gen',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontSize: 24,
                  color: CampusGptTheme.onSurface,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        // Actions
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context, 
                Icons.mic, 
                'Record', 
                'Live Lecture',
                CampusGptTheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionCard(
                context, 
                Icons.upload_file, 
                'Upload', 
                'PDF / PPT',
                CampusGptTheme.secondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        // Recent Drafts
        Text(
          'RECENT NOTES',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.5),
        ),
        const SizedBox(height: 16),
        _buildDraftCard(context, 'Advanced Thermodynamics', 'Lecture 4 Summary', '2 hrs ago'),
        const SizedBox(height: 12),
        _buildDraftCard(context, 'Data Structures', 'Graphs & Trees', 'Yesterday'),
        const SizedBox(height: 12),
        _buildDraftCard(context, 'Quantum Physics', 'Schrodinger Eq.', '3 days ago'),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context, IconData icon, String title, String subtitle, Color color) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }

  Widget _buildDraftCard(BuildContext context, String title, String subtitle, String time) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: CampusGptTheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.description, color: CampusGptTheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: CampusGptTheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          Text(
            time,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}
