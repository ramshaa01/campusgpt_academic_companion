import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_models.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../widgets/help_dialog.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  bool _isProcessing = false;

  Future<void> _processUpload(String type) async {
    setState(() => _isProcessing = true);

    String topicHint = type;
    if (type == 'Document') {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'ppt', 'pptx', 'doc', 'docx', 'txt'],
        withData: true,
      );
      if (result == null || result.files.isEmpty) {
        setState(() => _isProcessing = false);
        return;
      }
      final file = result.files.first;
      topicHint = file.name.replaceAll(RegExp(r'\.[^.]+$'), '');
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Processing $type... Please wait.'),
        backgroundColor: CampusGptTheme.secondaryContainer,
      ),
    );

    final appState = context.read<AppState>();
    final body = await appState.ai.generateNotes(
      sourceLabel: type,
      topicHint: topicHint,
    );

    await appState.addNote(
      title: topicHint,
      subtitle: 'Auto-generated notes',
      body: body,
    );

    if (!mounted) return;
    setState(() => _isProcessing = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notes generated successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showNoteDetail(NoteDraft note) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: CampusGptTheme.surfaceContainerHigh,
        title: Text(note.title, style: const TextStyle(color: CampusGptTheme.onSurface)),
        content: SingleChildScrollView(
          child: Text(note.body, style: Theme.of(context).textTheme.bodyMedium),
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

  @override
  Widget build(BuildContext context) {
    final notes = context.watch<AppState>().notes;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 64, 16, 120),
      children: [
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
              icon: const Icon(Icons.help_outline),
              onPressed: () => showHelpDialog(
                context,
                title: 'AI Notes Gen',
                body:
                    'Record a lecture or upload PDF/PPT/DOC files. CampusGPT generates structured study notes and saves them to your list automatically.',
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                Icons.mic,
                'Record',
                'Live Lecture',
                CampusGptTheme.primary,
                () => _processUpload('Audio Recording'),
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
                () => _processUpload('Document'),
              ),
            ),
          ],
        ),
        if (_isProcessing) ...[
          const SizedBox(height: 24),
          const LinearProgressIndicator(color: CampusGptTheme.primary),
        ],
        const SizedBox(height: 24),
        Text(
          'RECENT NOTES',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.5),
        ),
        const SizedBox(height: 16),
        ...notes.map(
          (draft) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () => _showNoteDetail(draft),
              child: _buildDraftCard(context, draft.title, draft.subtitle, draft.time),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Color color,
    VoidCallback onTap,
  ) {
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
            Text(title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 18)),
            const SizedBox(height: 4),
            Text(subtitle, style: Theme.of(context).textTheme.labelSmall),
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
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Text(time, style: Theme.of(context).textTheme.labelSmall),
        ],
      ),
    );
  }
}
