import 'dart:convert';
import 'package:http/http.dart' as http;

class AiService {
  static const _apiKey = String.fromEnvironment('OPENAI_API_KEY');

  Future<String> respond({
    required String userMessage,
    required List<Map<String, String>> history,
    required String userName,
  }) async {
    if (_apiKey.isNotEmpty) {
      try {
        return await _callOpenAi(userMessage, history, userName);
      } catch (_) {
        // Fall through to local engine if remote call fails.
      }
    }
    return _localResponse(userMessage, userName);
  }

  Future<String> generateNotes({
    required String sourceLabel,
    required String topicHint,
  }) async {
    if (_apiKey.isNotEmpty) {
      try {
        return await _callOpenAi(
          'Generate concise structured study notes for: $topicHint (source: $sourceLabel). Use headings and bullet points.',
          const [],
          'Student',
        );
      } catch (_) {}
    }
    return _localNotes(topicHint, sourceLabel);
  }

  Future<String> _callOpenAi(
    String userMessage,
    List<Map<String, String>> history,
    String userName,
  ) async {
    final messages = <Map<String, String>>[
      {
        'role': 'system',
        'content':
            'You are CampusGPT, a concise academic tutor for $userName. Focus on exam prep, notes, GPA, and attendance guidance.',
      },
      ...history.take(8).map(
            (m) => {
              'role': m['role'] == 'user' ? 'user' : 'assistant',
              'content': m['content'] ?? '',
            },
          ),
      {'role': 'user', 'content': userMessage},
    ];

    final response = await http.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'gpt-4o-mini',
        'messages': messages,
        'temperature': 0.7,
        'max_tokens': 700,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('OpenAI error ${response.statusCode}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final choices = body['choices'] as List<dynamic>;
    final message = choices.first['message'] as Map<String, dynamic>;
    return (message['content'] as String).trim();
  }

  String _localResponse(String input, String userName) {
    final text = input.toLowerCase();

    if (text.contains('quiz') || text.contains('thermo')) {
      return '''Here is a quick practice quiz, $userName:

1. **Carnot Efficiency** — Derive η = 1 − T₂/T₁ for a Carnot engine operating between reservoirs at T₁ and T₂.

2. **Entropy** — State the Clausius inequality and explain why entropy of an isolated system never decreases.

3. **Enthalpy** — For a steady-flow process, write the enthalpy balance and identify when Ẇ = ṁΔh.

Reply with your answers and I will review them step by step.''';
    }

    if (text.contains('carnot')) {
      return '''The **Carnot cycle** is an ideal reversible cycle with four steps:
• Isothermal expansion (absorbs Q₁ at T₁)
• Adiabatic expansion (temperature drops to T₂)
• Isothermal compression (rejects Q₂ at T₂)
• Adiabatic compression (returns to T₁)

Efficiency η = 1 − Q₂/Q₁ = 1 − T₂/T₁. It sets the upper limit for any heat engine between those temperatures.''';
    }

    if (text.contains('summarize') || text.contains('lecture')) {
      return '''**Lecture 4 Summary — Advanced Thermodynamics**

• **First Law:** ΔU = Q − W (sign conventions matter in open vs closed systems)
• **Second Law:** Real processes increase total entropy; reversible processes are ideal limits
• **Key topics:** Carnot cycle, entropy generation in irreversible flows, isentropic efficiency
• **Exam focus:** Derive efficiency, interpret T‑s diagrams, apply steady-flow energy equation

Want flashcards or 5 practice problems from this lecture?''';
    }

    if (text.contains('gpa') || text.contains('cgpa') || text.contains('sgpa')) {
      return '''To improve GPA strategically:
1. Prioritize high-credit courses where you are closest to the next grade band.
2. Aim for consistent SGPA rather than cramming one subject.
3. Use PYQ Analyzer to focus on high-frequency exam topics.
4. Track attendance — many programs require 75% minimum to sit exams.

Tell me your target CGPA and I can estimate the SGPA you need this semester.''';
    }

    if (text.contains('attendance')) {
      return '''Attendance tips:
• Mark each class right after it ends so your tracker stays accurate.
• If a subject is below 75%, attend the next required classes before optional ones.
• Use the warning banner in Attendance Tracker to see exactly how many classes you need.

Open the Attendance tab from your Dashboard to update today's classes.''';
    }

    return '''I can help with quizzes, lecture summaries, exam planning, GPA targets, and PYQ revision.

Try asking:
• "Quiz me on Thermodynamics"
• "Explain Carnot cycle"
• "Summarize Lecture 4"
• "What SGPA do I need for CGPA 8.5?"''';
  }

  String _localNotes(String topicHint, String sourceLabel) {
    final topic = topicHint.isNotEmpty ? topicHint : 'General Study Material';
    return '''# $topic
_Source: ${sourceLabel}_

## Key Concepts
• Define core terms and relationships before memorizing formulas.
• Connect each concept to a past-year question from PYQ Analyzer.

## Important Formulas
• Write unit-safe equations and note when each applies.
• Include one worked example per formula.

## Exam Checklist
1. Review definitions and assumptions
2. Practice 2 numerical problems
3. Revise frequently asked PYQ topics
4. Self-test with closed notes for 15 minutes

## Quick Recall Questions
• What are the boundary conditions?
• What assumptions make the model valid?
• Which graph/diagram is essential for this topic?''';
  }
}
