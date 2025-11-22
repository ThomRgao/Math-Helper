import 'dart:convert';

enum UserRole { student, admin }

class UserData {
  final String id;
  final String name;
  final String email;
  final String password;
  final String kelas;
  final String rombel;
  final UserRole role;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.kelas,
    required this.rombel,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'kelas': kelas,
        'rombel': rombel,
        'role': role.name,
      };

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        password: json['password'] as String,
        kelas: json['kelas'] as String,
        rombel: json['rombel'] as String,
        role: (json['role'] as String) == 'admin'
            ? UserRole.admin
            : UserRole.student,
      );
}

class ModuleData {
  final String id;
  final String title;
  final String description;
  final String kelas;

  ModuleData({
    required this.id,
    required this.title,
    required this.description,
    required this.kelas,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'kelas': kelas,
      };

  factory ModuleData.fromJson(Map<String, dynamic> json) => ModuleData(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        kelas: json['kelas'] as String,
      );
}

enum QuestionKind { bank, exam }

class Question {
  final String id;
  final String moduleId;
  final String text;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final QuestionKind kind;

  Question({
    required this.id,
    required this.moduleId,
    required this.text,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.kind,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'moduleId': moduleId,
        'text': text,
        'options': options,
        'correctIndex': correctIndex,
        'explanation': explanation,
        'kind': kind.name,
      };

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        id: json['id'] as String,
        moduleId: json['moduleId'] as String,
        text: json['text'] as String,
        options: (json['options'] as List).map((e) => e.toString()).toList(),
        correctIndex: json['correctIndex'] as int,
        explanation: json['explanation'] as String? ?? '',
        kind: (json['kind'] as String) == 'exam'
            ? QuestionKind.exam
            : QuestionKind.bank,
      );
}

class QuizHistoryItem {
  final String id;
  final String userId;
  final String moduleId;
  final DateTime dateTime;
  final int score;
  final int correctCount;
  final int totalCount;
  final QuestionKind kind;

  QuizHistoryItem({
    required this.id,
    required this.userId,
    required this.moduleId,
    required this.dateTime,
    required this.score,
    required this.correctCount,
    required this.totalCount,
    required this.kind,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'moduleId': moduleId,
        'dateTime': dateTime.toIso8601String(),
        'score': score,
        'correctCount': correctCount,
        'totalCount': totalCount,
        'kind': kind.name,
      };

  factory QuizHistoryItem.fromJson(Map<String, dynamic> json) =>
      QuizHistoryItem(
        id: json['id'] as String,
        userId: json['userId'] as String,
        moduleId: json['moduleId'] as String,
        dateTime: DateTime.parse(json['dateTime'] as String),
        score: json['score'] as int,
        correctCount: json['correctCount'] as int,
        totalCount: json['totalCount'] as int,
        kind: (json['kind'] as String) == 'exam'
            ? QuestionKind.exam
            : QuestionKind.bank,
      );
}

class AdminNotification {
  final String id;
  final String message;
  final DateTime dateTime;
  final bool read;

  AdminNotification({
    required this.id,
    required this.message,
    required this.dateTime,
    required this.read,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'message': message,
        'dateTime': dateTime.toIso8601String(),
        'read': read,
      };

  factory AdminNotification.fromJson(Map<String, dynamic> json) =>
      AdminNotification(
        id: json['id'] as String,
        message: json['message'] as String,
        dateTime: DateTime.parse(json['dateTime'] as String),
        read: json['read'] as bool? ?? false,
      );
}

String encodeList(List<Map<String, dynamic>> list) =>
    jsonEncode(list);

List<Map<String, dynamic>> decodeList(String? src) {
  if (src == null || src.isEmpty) return [];
  final raw = jsonDecode(src) as List;
  return raw.map((e) => e as Map<String, dynamic>).toList();
}
