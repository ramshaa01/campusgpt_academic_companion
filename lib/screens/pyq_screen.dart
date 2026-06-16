import 'package:flutter/material.dart';
import '../theme.dart';

class PyqScreen extends StatelessWidget {
  const PyqScreen({super.key});

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
                'PYQ Analyzer',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontSize: 24,
                  color: CampusGptTheme.onSurface,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        // Subject Selector
        GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: 'Advanced Thermodynamics',
              dropdownColor: CampusGptTheme.surfaceContainerHigh,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: CampusGptTheme.onSurface),
              items: ['Advanced Thermodynamics', 'Data Structures & Algos', 'Quantum Physics']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: CampusGptTheme.onSurface,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (_) {},
            ),
          ),
        ),
        const SizedBox(height: 24),
        
        // Trends Summary
        Row(
          children: [
            Expanded(
              child: GlassCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(Icons.trending_up, color: CampusGptTheme.secondary),
                    const SizedBox(height: 12),
                    Text(
                      'Top Topic',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Carnot Cycle',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: CampusGptTheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
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
                  children: [
                    const Icon(Icons.warning_amber, color: CampusGptTheme.error),
                    const SizedBox(height: 12),
                    Text(
                      'Difficulty',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'High (8.5/10)',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: CampusGptTheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        // Frequently Asked Questions
        Text(
          'FREQUENTLY ASKED (LAST 5 YEARS)',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.5),
        ),
        const SizedBox(height: 16),
        _buildQuestionCard(
          context, 
          'Derive the efficiency of a Carnot engine working between temperatures T1 and T2.',
          'Asked 4 times',
          'High Probability',
        ),
        const SizedBox(height: 12),
        _buildQuestionCard(
          context, 
          'Explain the Clausius inequality and its significance in thermodynamics.',
          'Asked 3 times',
          'Medium Probability',
        ),
        const SizedBox(height: 12),
        _buildQuestionCard(
          context, 
          'What is the physical significance of entropy? Discuss the principle of increase of entropy.',
          'Asked 3 times',
          'Medium Probability',
        ),
      ],
    );
  }

  Widget _buildQuestionCard(BuildContext context, String question, String frequency, String probability) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: CampusGptTheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  frequency,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
              Text(
                probability,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: probability.contains('High') 
                      ? CampusGptTheme.error 
                      : CampusGptTheme.secondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            question,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: CampusGptTheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.auto_awesome, size: 16),
              label: const Text('AI Hint'),
              style: TextButton.styleFrom(
                foregroundColor: CampusGptTheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
