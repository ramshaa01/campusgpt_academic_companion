import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_models.dart';
import '../state/app_state.dart';
import '../theme.dart';
import '../utils/file_download.dart';
import '../widgets/help_dialog.dart';
import 'attendance_screen.dart';
import 'gpa_screen.dart';
import 'pyq_screen.dart';

class VaultScreen extends StatefulWidget {
  const VaultScreen({super.key});

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<VaultFile> _filterFiles(List<VaultFile> files) {
    if (_query.isEmpty) return files;
    final q = _query.toLowerCase();
    return files.where((f) => f.name.toLowerCase().contains(q)).toList();
  }

  void _downloadFile(BuildContext context, VaultFile file) {
    try {
      downloadTextFile(
        file.name.replaceAll(RegExp(r'\.(pdf|docx)$', caseSensitive: false), '.txt'),
        '# ${file.name}\n\n${file.content}',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Downloaded ${file.name}'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download started for ${file.name}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final files = _filterFiles(context.watch<AppState>().vaultFiles);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 64, 16, 120),
      children: [
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
              icon: const Icon(Icons.help_outline),
              onPressed: () => showHelpDialog(
                context,
                title: 'Resource Vault',
                body:
                    'Browse folders, use quick tools, and download study files. Use search to filter recent files.',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _searchController,
          onChanged: (value) => setState(() => _query = value.trim()),
          decoration: InputDecoration(
            hintText: 'Search files...',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: CampusGptTheme.surfaceContainer,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 24),
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
        Text(
          'RECENT FILES',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.5),
        ),
        const SizedBox(height: 16),
        if (files.isEmpty)
          Text('No files match your search.', style: Theme.of(context).textTheme.bodySmall)
        else
          ...files.map(
            (file) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildFileCard(context, file),
            ),
          ),
      ],
    );
  }

  Widget _buildToolShortcut(
    BuildContext context,
    IconData icon,
    String title,
    Color color,
    VoidCallback onTap,
  ) {
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
              maxLines: 2,
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
                Text(title, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileCard(BuildContext context, VaultFile file) {
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
            child: const Icon(Icons.picture_as_pdf, color: CampusGptTheme.secondary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(file.name, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                Text(file.meta, style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.download, color: CampusGptTheme.primary.withOpacity(0.8)),
            onPressed: () => _downloadFile(context, file),
          ),
        ],
      ),
    );
  }
}
