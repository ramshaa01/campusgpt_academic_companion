import 'package:flutter/material.dart';
import '../theme.dart';

class PyqData {
  final String topTopic;
  final String difficulty;
  final List<Map<String, String>> questions;

  PyqData({
    required this.topTopic,
    required this.difficulty,
    required this.questions,
  });
}

class PyqScreen extends StatefulWidget {
  const PyqScreen({super.key});

  @override
  State<PyqScreen> createState() => _PyqScreenState();
}

class _PyqScreenState extends State<PyqScreen> {
  String _selectedSubject = 'Advanced Thermodynamics';

  final Map<String, PyqData> _mockData = {
    'Advanced Thermodynamics': PyqData(
      topTopic: 'Carnot Cycle',
      difficulty: 'High (8.5/10)',
      questions: [
        {
          'q': 'Derive the efficiency of a Carnot engine working between temperatures T1 and T2.',
          'freq': 'Asked 4 times',
          'prob': 'High Probability',
          'hint':
              'Start with the PV diagram. Calculate heat absorbed (Q1) during isothermal expansion and heat rejected (Q2) during isothermal compression. Efficiency = 1 - Q2/Q1.',
        },
        {
          'q': 'Explain the Clausius inequality and its significance in thermodynamics.',
          'freq': 'Asked 3 times',
          'prob': 'Medium Probability',
          'hint':
              'The cyclic integral of dQ/T is less than or equal to zero. Mention how it differentiates between reversible and irreversible processes.',
        },
        {
          'q': 'What is the physical significance of entropy? Discuss the principle of increase of entropy.',
          'freq': 'Asked 3 times',
          'prob': 'Medium Probability',
          'hint':
              'Relate entropy to disorder/randomness. State the second law in terms of isolated systems always moving towards maximum entropy.',
        },
      ],
    ),
    'Data Structures & Algos': PyqData(
      topTopic: 'Dynamic Programming',
      difficulty: 'Very High (9.0/10)',
      questions: [
        {
          'q': "Explain Dijkstra's shortest path algorithm with an example.",
          'freq': 'Asked 5 times',
          'prob': 'High Probability',
          'hint':
              'Use a priority queue. Initialize all distances to infinity, start node to 0. Greedily pick the minimum distance node and relax its edges.',
        },
        {
          'q': 'Write a recursive and iterative function for binary search.',
          'freq': 'Asked 3 times',
          'prob': 'Medium Probability',
          'hint':
              'Ensure the array is sorted. Keep track of low and high indices, calculate mid, and divide the search space by half.',
        },
      ],
    ),
    'Quantum Physics': PyqData(
      topTopic: 'Schrödinger Eq.',
      difficulty: 'Medium (7.0/10)',
      questions: [
        {
          'q': 'Derive the time-independent Schrödinger wave equation.',
          'freq': 'Asked 4 times',
          'prob': 'High Probability',
          'hint':
              'Start with the classical wave equation. Use de Broglie wavelength and substitute the momentum operator to arrive at the Hamiltonian operator form.',
        },
      ],
    ),
  };

  void _showHintDialog(String question, String hint) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: CampusGptTheme.surfaceContainerHigh,
        title: const Row(
          children: [
            Icon(Icons.auto_awesome, color: CampusGptTheme.primary),
            SizedBox(width: 8),
            Text('Study Hint', style: TextStyle(color: CampusGptTheme.onSurface)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question, style: Theme.of(context).textTheme.labelSmall?.copyWith(fontStyle: FontStyle.italic)),
            const SizedBox(height: 16),
            Text(hint, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: CampusGptTheme.onSurface)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it', style: TextStyle(color: CampusGptTheme.primary)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentData = _mockData[_selectedSubject]!;

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
        GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedSubject,
              dropdownColor: CampusGptTheme.surfaceContainerHigh,
              isExpanded: true,
              items: _mockData.keys.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) setState(() => _selectedSubject = value);
              },
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: GlassCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(Icons.trending_up, color: CampusGptTheme.secondary),
                    const SizedBox(height: 12),
                    Text('Top Topic', style: Theme.of(context).textTheme.labelSmall),
                    const SizedBox(height: 4),
                    Text(
                      currentData.topTopic,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
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
                    Text('Difficulty', style: Theme.of(context).textTheme.labelSmall),
                    const SizedBox(height: 4),
                    Text(
                      currentData.difficulty,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'FREQUENTLY ASKED (LAST 5 YEARS)',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(letterSpacing: 1.5),
        ),
        const SizedBox(height: 16),
        ...currentData.questions.map(
          (q) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildQuestionCard(context, q['q']!, q['freq']!, q['prob']!, q['hint']!),
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionCard(
    BuildContext context,
    String question,
    String frequency,
    String probability,
    String hint,
  ) {
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
                child: Text(frequency, style: Theme.of(context).textTheme.labelSmall),
              ),
              Text(
                probability,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: probability.contains('High') ? CampusGptTheme.error : CampusGptTheme.secondary,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(question, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () => _showHintDialog(question, hint),
              icon: const Icon(Icons.auto_awesome, size: 16),
              label: const Text('Study Hint'),
            ),
          ),
        ],
      ),
    );
  }
}
