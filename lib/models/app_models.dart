import 'dart:convert';

class UserAccount {
  final String id;
  final String name;
  final String email;
  final String passwordHash;

  const UserAccount({
    required this.id,
    required this.name,
    required this.email,
    required this.passwordHash,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'passwordHash': passwordHash,
      };

  factory UserAccount.fromJson(Map<String, dynamic> json) => UserAccount(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        passwordHash: json['passwordHash'] as String,
      );
}

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
    final required = 3 * total - 4 * attended;
    return required > 0 ? required : 0;
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'attended': attended,
        'total': total,
      };

  factory SubjectAttendance.fromJson(Map<String, dynamic> json) =>
      SubjectAttendance(
        title: json['title'] as String,
        attended: json['attended'] as int,
        total: json['total'] as int,
      );
}

class NoteDraft {
  final String id;
  final String title;
  final String subtitle;
  final String body;
  final String time;
  final DateTime createdAt;

  NoteDraft({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.time,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'body': body,
        'time': time,
        'createdAt': createdAt.toIso8601String(),
      };

  factory NoteDraft.fromJson(Map<String, dynamic> json) => NoteDraft(
        id: json['id'] as String,
        title: json['title'] as String,
        subtitle: json['subtitle'] as String,
        body: json['body'] as String,
        time: json['time'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

class ChatMessage {
  final String role;
  final String content;
  final DateTime timestamp;

  ChatMessage({
    required this.role,
    required this.content,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'role': role,
        'content': content,
        'timestamp': timestamp.toIso8601String(),
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        role: json['role'] as String,
        content: json['content'] as String,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}

class ExamEvent {
  final String id;
  final int daysRemaining;
  final String title;
  final String subtitle;
  final DateTime date;

  ExamEvent({
    required this.id,
    required this.daysRemaining,
    required this.title,
    required this.subtitle,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'daysRemaining': daysRemaining,
        'title': title,
        'subtitle': subtitle,
        'date': date.toIso8601String(),
      };

  factory ExamEvent.fromJson(Map<String, dynamic> json) => ExamEvent(
        id: json['id'] as String,
        daysRemaining: json['daysRemaining'] as int,
        title: json['title'] as String,
        subtitle: json['subtitle'] as String,
        date: DateTime.parse(json['date'] as String),
      );
}

class VaultFile {
  final String id;
  final String name;
  final String meta;
  final String content;

  VaultFile({
    required this.id,
    required this.name,
    required this.meta,
    required this.content,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'meta': meta,
        'content': content,
      };

  factory VaultFile.fromJson(Map<String, dynamic> json) => VaultFile(
        id: json['id'] as String,
        name: json['name'] as String,
        meta: json['meta'] as String,
        content: json['content'] as String,
      );
}

List<T> decodeList<T>(
  String? raw,
  T Function(Map<String, dynamic>) fromJson,
) {
  if (raw == null || raw.isEmpty) return [];
  final decoded = jsonDecode(raw) as List<dynamic>;
  return decoded.map((e) => fromJson(e as Map<String, dynamic>)).toList();
}

String encodeList<T>(List<T> items, Map<String, dynamic> Function(T) toJson) {
  return jsonEncode(items.map(toJson).toList());
}
