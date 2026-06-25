class GpaCalculator {
  static const double defaultCurrentCgpa = 8.2;
  static const int completedSemesters = 6;
  static const int currentSemesterCredits = 13;

  /// Estimates SGPA needed this semester to reach [targetCgpa].
  static double requiredSgpa({
    required double currentCgpa,
    required double targetCgpa,
    int pastSemesters = completedSemesters,
    int currentCredits = currentSemesterCredits,
  }) {
    if (currentCredits <= 0) return 10.0;
    final completedCredits = pastSemesters * 20.0;
    final totalPastPoints = currentCgpa * completedCredits;
    final totalCreditsAfter = completedCredits + currentCredits;
    final requiredPoints = targetCgpa * totalCreditsAfter;
    final neededThisSemester = requiredPoints - totalPastPoints;
    final sgpa = neededThisSemester / currentCredits;
    return sgpa.clamp(0.0, 10.0);
  }

  static String adviceText({
    required double currentCgpa,
    required double targetCgpa,
  }) {
    final sgpa = requiredSgpa(
      currentCgpa: currentCgpa,
      targetCgpa: targetCgpa,
    );
    if (targetCgpa <= currentCgpa) {
      return 'You are already at or above your target CGPA of ${targetCgpa.toStringAsFixed(1)}. Keep maintaining your performance.';
    }
    if (sgpa >= 9.95) {
      return 'Reaching ${targetCgpa.toStringAsFixed(1)} may be very difficult this semester. Consider adjusting your target or focusing on high-credit courses.';
    }
    return 'To reach ${targetCgpa.toStringAsFixed(1)}, you need an SGPA of ${sgpa.toStringAsFixed(1)} this semester (${currentSemesterCredits} credits).';
  }

  static int computeAiScore({
    required double attendancePercent,
    required int notesCount,
    required int chatMessages,
    required double currentCgpa,
  }) {
    final attendanceScore = (attendancePercent / 100 * 35).round();
    final notesScore = (notesCount.clamp(0, 10) / 10 * 25).round();
    final chatScore = (chatMessages.clamp(0, 20) / 20 * 20).round();
    final gpaScore = ((currentCgpa / 10) * 20).round();
    return (attendanceScore + notesScore + chatScore + gpaScore).clamp(0, 100);
  }
}
