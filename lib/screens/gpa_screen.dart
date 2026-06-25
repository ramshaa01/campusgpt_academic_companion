import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme.dart';

class GpaScreen extends StatelessWidget {
  const GpaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final targetGpa = appState.targetGpa;
    final currentCgpa = appState.currentCgpa;

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
                'GPA Predictor',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontSize: 24,
                      color: CampusGptTheme.onSurface,
                    ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text('Current CGPA', style: Theme.of(context).textTheme.labelSmall),
                    const SizedBox(height: 8),
                    Text(
                      currentCgpa.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: CampusGptTheme.onSurface,
                            fontSize: 36,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Target CGPA',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(color: CampusGptTheme.secondary),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      targetGpa.toStringAsFixed(1),
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: CampusGptTheme.secondary,
                            fontSize: 36,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        GlassCard(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Set your target',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: CampusGptTheme.onSurface,
                    ),
              ),
              const SizedBox(height: 16),
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: CampusGptTheme.secondary,
                  inactiveTrackColor: CampusGptTheme.surfaceContainerHighest,
                  thumbColor: CampusGptTheme.secondaryContainer,
                  overlayColor: CampusGptTheme.secondary.withOpacity(0.2),
                ),
                child: Slider(
                  value: targetGpa,
                  min: 5.0,
                  max: 10.0,
                  divisions: 50,
                  label: targetGpa.toStringAsFixed(1),
                  onChanged: (value) => appState.setTargetGpa(value),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: CampusGptTheme.primaryContainer.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: CampusGptTheme.primary.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: CampusGptTheme.primary, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        appState.gpaAdvice,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: CampusGptTheme.onSurface,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'COURSE PREDICTIONS',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.5),
        ),
        const SizedBox(height: 16),
        _buildCourseRow(context, 'Advanced Thermodynamics', '4 Credits', 'A'),
        const SizedBox(height: 12),
        _buildCourseRow(context, 'Data Structures & Algos', '4 Credits', 'A+'),
        const SizedBox(height: 12),
        _buildCourseRow(context, 'Quantum Physics', '3 Credits', 'B+'),
        const SizedBox(height: 12),
        _buildCourseRow(context, 'Technical Communication', '2 Credits', 'A'),
      ],
    );
  }

  Widget _buildCourseRow(BuildContext context, String title, String credits, String grade) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
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
                Text(credits, style: Theme.of(context).textTheme.labelSmall),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: CampusGptTheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              grade,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: CampusGptTheme.primary),
            ),
          ),
        ],
      ),
    );
  }
}
