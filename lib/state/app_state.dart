import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/app_models.dart';
import '../services/ai_service.dart';
import '../services/auth_service.dart';
import '../services/gpa_calculator.dart';
import '../services/storage_service.dart';

class AppState extends ChangeNotifier {
  AppState(this._storage) {
    auth = AuthService(_storage);
    ai = AiService();
  }

  final StorageService _storage;
  late final AuthService auth;
  late final AiService ai;

  UserAccount? user;
  bool isOnline = true;
  bool isLoading = true;
  bool isAiThinking = false;

  List<SubjectAttendance> subjects = [];
  List<NoteDraft> notes = [];
  List<ChatMessage> chatMessages = [];
  List<ExamEvent> exams = [];
  List<VaultFile> vaultFiles = [];

  double targetGpa = 8.5;
  double currentCgpa = GpaCalculator.defaultCurrentCgpa;
  int streakDays = 1;

  static const _subjectsKey = 'data_subjects';
  static const _notesKey = 'data_notes';
  static const _chatKey = 'data_chat';
  static const _examsKey = 'data_exams';
  static const _vaultKey = 'data_vault';
  static const _targetGpaKey = 'data_target_gpa';
  static const _currentCgpaKey = 'data_current_cgpa';
  static const _streakKey = 'data_streak';
  static const _lastActiveKey = 'data_last_active';

  Future<void> load() async {
    isLoading = true;
    notifyListeners();

    await auth.ensureDemoAccount();
    user = await auth.currentUser();

    subjects = decodeList(
      _storage.getString(_subjectsKey),
      SubjectAttendance.fromJson,
    );
    if (subjects.isEmpty) subjects = _defaultSubjects();

    notes = decodeList(_storage.getString(_notesKey), NoteDraft.fromJson);
    if (notes.isEmpty) notes = _defaultNotes();

    chatMessages = decodeList(_storage.getString(_chatKey), ChatMessage.fromJson);
    if (chatMessages.isEmpty) chatMessages = [_defaultWelcomeMessage()];

    exams = decodeList(_storage.getString(_examsKey), ExamEvent.fromJson);
    if (exams.isEmpty) exams = _defaultExams();

    vaultFiles = decodeList(_storage.getString(_vaultKey), VaultFile.fromJson);
    if (vaultFiles.isEmpty) vaultFiles = _defaultVaultFiles();

    targetGpa = _storage.getDouble(_targetGpaKey, fallback: 8.5);
    currentCgpa = _storage.getDouble(_currentCgpaKey, fallback: GpaCalculator.defaultCurrentCgpa);
    streakDays = _storage.getInt(_streakKey, fallback: 1);

    _updateStreak();
    isLoading = false;
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    user = await auth.signIn(email: email, password: password);
    _updateStreak();
    notifyListeners();
  }

  Future<void> signUp(String name, String email, String password) async {
    user = await auth.signUp(name: name, email: email, password: password);
    _updateStreak();
    notifyListeners();
  }

  Future<void> signOut() async {
    await auth.signOut();
    user = null;
    notifyListeners();
  }

  void setOnline(bool value) {
    if (isOnline == value) return;
    isOnline = value;
    notifyListeners();
  }

  double get overallAttendance {
    final attended = subjects.fold<int>(0, (s, i) => s + i.attended);
    final total = subjects.fold<int>(0, (s, i) => s + i.total);
    if (total == 0) return 0;
    return attended / total * 100;
  }

  int get aiScore => GpaCalculator.computeAiScore(
        attendancePercent: overallAttendance,
        notesCount: notes.length,
        chatMessages: chatMessages.where((m) => m.role == 'user').length,
        currentCgpa: currentCgpa,
      );

  String get gpaAdvice => GpaCalculator.adviceText(
        currentCgpa: currentCgpa,
        targetCgpa: targetGpa,
      );

  Future<void> setTargetGpa(double value) async {
    targetGpa = value;
    await _storage.setDouble(_targetGpaKey, value);
    notifyListeners();
  }

  Future<void> markAttendance(int index, bool present) async {
    if (present) {
      subjects[index].attended++;
    }
    subjects[index].total++;
    await _persistSubjects();
    notifyListeners();
  }

  Future<void> addNote({
    required String title,
    required String subtitle,
    required String body,
  }) async {
    notes.insert(
      0,
      NoteDraft(
        id: const Uuid().v4(),
        title: title,
        subtitle: subtitle,
        body: body,
        time: 'Just now',
        createdAt: DateTime.now(),
      ),
    );
    await _persistNotes();
    notifyListeners();
  }

  Future<void> sendChatMessage(String text) async {
    if (text.trim().isEmpty || isAiThinking) return;

    chatMessages.insert(0, ChatMessage(role: 'user', content: text.trim()));
    await _persistChat();
    isAiThinking = true;
    notifyListeners();

    final history = chatMessages.reversed
        .map((m) => {'role': m.role, 'content': m.content})
        .toList();

    final reply = await ai.respond(
      userMessage: text.trim(),
      history: history,
      userName: user?.name ?? 'Student',
    );

    chatMessages.insert(0, ChatMessage(role: 'ai', content: reply));
    isAiThinking = false;
    await _persistChat();
    notifyListeners();
  }

  Future<void> clearChat() async {
    chatMessages = [_defaultWelcomeMessage()];
    await _persistChat();
    notifyListeners();
  }

  Future<void> _persistSubjects() async {
    await _storage.setString(
      _subjectsKey,
      encodeList(subjects, (s) => s.toJson()),
    );
  }

  Future<void> _persistNotes() async {
    await _storage.setString(
      _notesKey,
      encodeList(notes, (n) => n.toJson()),
    );
  }

  Future<void> _persistChat() async {
    await _storage.setString(
      _chatKey,
      encodeList(chatMessages, (m) => m.toJson()),
    );
  }

  void _updateStreak() {
    final today = DateTime.now();
    final todayKey =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    final last = _storage.getString(_lastActiveKey);
    if (last == todayKey) return;

    if (last != null) {
      final parts = last.split('-');
      final lastDate = DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
      final diff = today.difference(lastDate).inDays;
      streakDays = diff == 1 ? streakDays + 1 : 1;
    } else {
      streakDays = 1;
    }

    _storage.setString(_lastActiveKey, todayKey);
    _storage.setInt(_streakKey, streakDays);
  }

  List<SubjectAttendance> _defaultSubjects() => [
        SubjectAttendance(title: 'Mathematics III', attended: 32, total: 36),
        SubjectAttendance(title: 'Physics - Quantum', attended: 25, total: 35),
        SubjectAttendance(title: 'Computer Science', attended: 29, total: 34),
      ];

  List<NoteDraft> _defaultNotes() => [
        NoteDraft(
          id: const Uuid().v4(),
          title: 'Advanced Thermodynamics',
          subtitle: 'Lecture 4 Summary',
          body: 'Summary of entropy, Carnot cycle, and second law.',
          time: '2 hrs ago',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        NoteDraft(
          id: const Uuid().v4(),
          title: 'Data Structures',
          subtitle: 'Graphs & Trees',
          body: 'BFS, DFS, shortest path overview.',
          time: 'Yesterday',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        NoteDraft(
          id: const Uuid().v4(),
          title: 'Quantum Physics',
          subtitle: 'Schrödinger Eq.',
          body: 'Time-independent Schrödinger equation notes.',
          time: '3 days ago',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ];

  ChatMessage _defaultWelcomeMessage() => ChatMessage(
        role: 'ai',
        content:
            "Hi! I noticed you have Advanced Thermodynamics final in 3 days. Would you like a practice quiz based on past papers?",
      );

  List<ExamEvent> _defaultExams() {
    final now = DateTime.now();
    return [
      ExamEvent(
        id: const Uuid().v4(),
        daysRemaining: 3,
        title: 'Advanced Thermodynamics',
        subtitle: 'Final Assessment • Hall 4B',
        date: now.add(const Duration(days: 3)),
      ),
      ExamEvent(
        id: const Uuid().v4(),
        daysRemaining: 8,
        title: 'Data Structures & Algos',
        subtitle: 'Midterm • LT-12',
        date: now.add(const Duration(days: 8)),
      ),
      ExamEvent(
        id: const Uuid().v4(),
        daysRemaining: 14,
        title: 'Quantum Physics',
        subtitle: 'Midterm • Hall 2A',
        date: now.add(const Duration(days: 14)),
      ),
      ExamEvent(
        id: const Uuid().v4(),
        daysRemaining: 21,
        title: 'Technical Communication',
        subtitle: 'Presentation • Room 301',
        date: now.add(const Duration(days: 21)),
      ),
    ];
  }

  List<VaultFile> _defaultVaultFiles() => [
        VaultFile(
          id: const Uuid().v4(),
          name: 'Thermodynamics_CheatSheet.pdf',
          meta: 'PDF • 2.4 MB',
          content: 'Carnot cycle, entropy, enthalpy quick reference.',
        ),
        VaultFile(
          id: const Uuid().v4(),
          name: 'Midterm_Syllabus.docx',
          meta: 'DOCX • 145 KB',
          content: 'Midterm syllabus and grading rubric.',
        ),
        VaultFile(
          id: const Uuid().v4(),
          name: 'Lecture_5_Notes.pdf',
          meta: 'PDF • 1.1 MB',
          content: 'Lecture 5 notes on thermodynamic potentials.',
        ),
      ];
}
