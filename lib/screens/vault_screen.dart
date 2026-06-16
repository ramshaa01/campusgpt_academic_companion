import 'package:flutter/material.dart';
import '../theme.dart';
import 'gpa_screen.dart';
import 'pyq_screen.dart';
import 'attendance_screen.dart';

class VaultScreen extends StatelessWidget {
  const VaultScreen({super.key});

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
                'Resource Vault',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontSize: 24,
                  color: CampusGptTheme.onSurface,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Tools shortcuts (linking to the other tools)
        Text(
          'QUICK TOOLS',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.5),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildToolShortcut(
                context, 
                Icons.analytics, 
                'PYQ Analyzer', 
                CampusGptTheme.tertiary,
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PyqScreen())),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildToolShortcut(
                context, 
                Icons.calculate, 
                'GPA Predictor', 
                CampusGptTheme.secondary,
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GpaScreen())),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildToolShortcut(
                context, 
                Icons.fact_check, 
                'Attendance', 
                Colors.greenAccent,
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AttendanceScreen())),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        
        // Folders
        Text(
          'YOUR FOLDERS',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.5),
        ),
        const SizedBox(height: 16),
        _buildFolderCard(context, 'Advanced Thermodynamics', '12 Files • Updated Today'),
        const SizedBox(height: 12),
        _buildFolderCard(context, 'Data Structures & Algos', '24 Files • Updated Yesterday'),
        const SizedBox(height: 12),
        _buildFolderCard(context, 'Quantum Physics', '8 Files • Updated last week'),
        
        const SizedBox(height: 32),
        
        // Recent Files
        Text(
          'RECENT FILES',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.5),
        ),
        const SizedBox(height: 16),
        _buildFileCard(context, 'Thermodynamics_CheatSheet.pdf', 'PDF • 2.4 MB', Icons.picture_as_pdf),
        const SizedBox(height: 12),
        _buildFileCard(context, 'Midterm_Syllabus.docx', 'DOCX • 145 KB', Icons.description),
        const SizedBox(height: 12),
        _buildFileCard(context, 'Lecture_5_Notes.pdf', 'PDF • 1.1 MB', Icons.picture_as_pdf),
      ],
    );
  }

  Widget _buildToolShortcut(BuildContext context, IconData icon, String title, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFolderCard(BuildContext context, String title, String subtitle) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(Icons.folder, color: CampusGptTheme.primary.withOpacity(0.8), size: 32),
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
          Icon(Icons.more_vert, color: CampusGptTheme.onSurfaceVariant.withOpacity(0.5)),
        ],
      ),
    );
  }

  Widget _buildFileCard(BuildContext context, String title, String subtitle, IconData icon) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: CampusGptTheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: CampusGptTheme.secondary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: CampusGptTheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
          Icon(Icons.download, color: CampusGptTheme.primary.withOpacity(0.8)),
        ],
      ),
    );
  }
}
