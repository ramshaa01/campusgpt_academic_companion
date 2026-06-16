import 'package:flutter/material.dart';
import '../theme.dart';

class NoteDraft {
  final String title;
  final String subtitle;
  final String time;

  NoteDraft({required this.title, required this.subtitle, required this.time});
}

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final List<NoteDraft> _drafts = [
    NoteDraft(title: 'Advanced Thermodynamics', subtitle: 'Lecture 4 Summary', time: '2 hrs ago'),
    NoteDraft(title: 'Data Structures', subtitle: 'Graphs & Trees', time: 'Yesterday'),
    NoteDraft(title: 'Quantum Physics', subtitle: 'Schrodinger Eq.', time: '3 days ago'),
  ];

  bool _isProcessing = false;

  void _simulateProcessing(String type) async {
    setState(() {
      _isProcessing = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Processing $type... Please wait.'),
        backgroundColor: CampusGptTheme.secondaryContainer,
      ),
    );

    // Simulate network/processing delay
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isProcessing = false;
      _drafts.insert(0, NoteDraft(
        title: 'New $type Upload', 
        subtitle: 'Auto-generated notes', 
        time: 'Just now'
      ));
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notes generated successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

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
                () => _simulateProcessing('Audio Recording'),
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
                () => _simulateProcessing('Document'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        if (_isProcessing) ...[
          const LinearProgressIndicator(color: CampusGptTheme.primary),
          const SizedBox(height: 24),
        ],

        // Recent Drafts
        Text(
          'RECENT NOTES',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.5),
        ),
        const SizedBox(height: 16),
        ..._drafts.map((draft) => Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: _buildDraftCard(context, draft.title, draft.subtitle, draft.time),
        )).toList(),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context, IconData icon, String title, String subtitle, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: _isProcessing ? null : onTap,
      child: GlassCard(
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
