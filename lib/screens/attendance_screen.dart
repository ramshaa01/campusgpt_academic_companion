import 'package:flutter/material.dart';
import '../theme.dart';

class SubjectAttendance {
  final String title;
  int attended;
  int total;

  SubjectAttendance({
    required this.title,
    required this.attended,
    required this.total,
  });

  double get percentage => total == 0 ? 0.0 : (attended / total) * 100;
  bool get isSafe => percentage >= 75.0;

  int classesToReachSafe() {
    if (isSafe) return 0;
    // We need (attended + x) / (total + x) >= 0.75
    // attended + x >= 0.75 * total + 0.75 * x
    // 0.25 * x >= 0.75 * total - attended
    // x >= 3 * total - 4 * attended
    int required = (3 * total - 4 * attended);
    return required > 0 ? required : 0;
  }
}

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final List<SubjectAttendance> _subjects = [
    SubjectAttendance(title: 'Mathematics III', attended: 32, total: 36),
    SubjectAttendance(title: 'Physics - Quantum', attended: 25, total: 35),
    SubjectAttendance(title: 'Computer Science', attended: 29, total: 34),
  ];

  double get _overallAttendance {
    int totalAttended = _subjects.fold(0, (sum, item) => sum + item.attended);
    int totalClasses = _subjects.fold(0, (sum, item) => sum + item.total);
    return totalClasses == 0 ? 0.0 : (totalAttended / totalClasses) * 100;
  }

  void _markAttendance(int index, bool present) {
    setState(() {
      if (present) {
        _subjects[index].attended++;
      }
      _subjects[index].total++;
    });
    
    // Show a small feedback snackbar
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(present ? 'Marked Present' : 'Marked Absent'),
        backgroundColor: present ? Colors.green : CampusGptTheme.error,
        duration: const Duration(seconds: 1),
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
                    _overallAttendance.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: _overallAttendance >= 75.0 ? CampusGptTheme.primary : CampusGptTheme.error,
                    ),
                  ),
                  Text(
                    '%',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: _overallAttendance >= 75.0 ? CampusGptTheme.primary : CampusGptTheme.error,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _overallAttendance >= 75.0 ? Colors.green.withOpacity(0.1) : CampusGptTheme.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _overallAttendance >= 75.0 ? Colors.green.withOpacity(0.3) : CampusGptTheme.error.withOpacity(0.3)
                  ),
                ),
                child: Text(
                  _overallAttendance >= 75.0 ? 'SAFE (Target: 75%)' : 'WARNING (Target: 75%)',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: _overallAttendance >= 75.0 ? Colors.greenAccent : CampusGptTheme.error,
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
        ...List.generate(_subjects.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: _buildSubjectCard(index),
          );
        }),
      ],
    );
  }

  Widget _buildSubjectCard(int index) {
    final subject = _subjects[index];
    final isSafe = subject.isSafe;

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  subject.title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: CampusGptTheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
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
                    '${subject.percentage.toStringAsFixed(1)}%',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    '${subject.attended}/${subject.total} Classes',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
              Row(
                children: [
                  _buildActionButton(Icons.close, CampusGptTheme.error, () => _markAttendance(index, false)),
                  const SizedBox(width: 8),
                  _buildActionButton(Icons.check, Colors.greenAccent, () => _markAttendance(index, true)),
                ],
              ),
            ],
          ),
          if (!isSafe) ...[
            const SizedBox(height: 16),
            Text(
              '⚠️ Attend next ${subject.classesToReachSafe()} classes to reach 75%',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: CampusGptTheme.error,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, Color color, VoidCallback onPressed) {
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
        onPressed: onPressed,
      ),
    );
  }
}
