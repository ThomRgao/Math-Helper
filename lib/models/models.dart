import 'package:flutter/material.dart';

const Color kPrimaryColor = Color(0xFFE24A3A);
const Color kBackgroundColor = Color(0xFFF5F5F5);
const Color kTextColor = Color(0xFF222222);
const double kDefaultPadding = 16;

enum UserRole { student, admin }

class ModuleData {
  final String id;
  final String title;
  final String subtitle;
  final String description;

  const ModuleData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
  });
}

class Question {
  final String id;
  final String moduleId;
  final String text;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const Question({
    required this.id,
    required this.moduleId,
    required this.text,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}

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
        id: json['id'],
        name: json['name'],
        email: json['email'],
        password: json['password'],
        kelas: json['kelas'],
        rombel: json['rombel'],
        role: json['role'] == 'admin' ? UserRole.admin : UserRole.student,
      );
}

class QuizHistoryItem {
  final String id;
  final String userId;
  final String moduleId;
  final String type;
  final int score;
  final DateTime dateTime;

  QuizHistoryItem({
    required this.id,
    required this.userId,
    required this.moduleId,
    required this.type,
    required this.score,
    required this.dateTime,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'moduleId': moduleId,
        'type': type,
        'score': score,
        'dateTime': dateTime.toIso8601String(),
      };

  factory QuizHistoryItem.fromJson(Map<String, dynamic> json) =>
      QuizHistoryItem(
        id: json['id'],
        userId: json['userId'],
        moduleId: json['moduleId'],
        type: json['type'],
        score: json['score'],
        dateTime: DateTime.parse(json['dateTime']),
      );
}

class AdminNotification {
  final String id;
  final String message;
  final DateTime dateTime;

  AdminNotification({
    required this.id,
    required this.message,
    required this.dateTime,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'message': message,
        'dateTime': dateTime.toIso8601String(),
      };

  factory AdminNotification.fromJson(Map<String, dynamic> json) =>
      AdminNotification(
        id: json['id'],
        message: json['message'],
        dateTime: DateTime.parse(json['dateTime']),
      );
}

const List<ModuleData> kModules = [
  ModuleData(
    id: 'mod1',
    title: 'Bilangan Bulat',
    subtitle: 'Operasi hitung bilangan bulat',
    description:
        'Materi bilangan bulat membahas penjumlahan, pengurangan, perkalian, dan pembagian pada bilangan positif dan negatif, termasuk penerapannya dalam kehidupan sehari-hari.',
  ),
  ModuleData(
    id: 'mod2',
    title: 'KPK & FPB',
    subtitle: 'Kelipatan dan faktor',
    description:
        'Materi KPK dan FPB membahas cara menentukan kelipatan persekutuan terkecil dan faktor persekutuan terbesar menggunakan faktorisasi prima maupun tabel.',
  ),
  ModuleData(
    id: 'mod3',
    title: 'Pecahan',
    subtitle: 'Operasi pecahan',
    description:
        'Materi pecahan membahas bentuk pecahan biasa, campuran, desimal, dan persen, serta operasi penjumlahan, pengurangan, perkalian, dan pembagian pecahan.',
  ),
  ModuleData(
    id: 'mod4',
    title: 'PLSV',
    subtitle: 'Persamaan linear satu variabel',
    description:
        'Materi PLSV membahas cara menyusun dan menyelesaikan persamaan linear satu variabel dari permasalahan kontekstual.',
  ),
  ModuleData(
    id: 'mod5',
    title: 'Geometri Dasar',
    subtitle: 'Bangun datar',
    description:
        'Materi geometri dasar membahas keliling dan luas bangun datar seperti persegi, persegi panjang, segitiga, dan lingkaran.',
  ),
];

const List<Question> kBankQuestions = [
  Question(
    id: 'b1',
    moduleId: 'mod1',
    text: 'Hasil dari 7 + (−5) adalah',
    options: ['2', '−2', '12', '−12'],
    correctIndex: 0,
    explanation: '7 + (−5) = 7 − 5 = 2.',
  ),
  Question(
    id: 'b2',
    moduleId: 'mod1',
    text: 'Hasil dari −8 − 5 adalah',
    options: ['−3', '3', '−13', '13'],
    correctIndex: 2,
    explanation: '−8 − 5 = −8 + (−5) = −13.',
  ),
  Question(
    id: 'b3',
    moduleId: 'mod2',
    text: 'KPK dari 6 dan 8 adalah',
    options: ['12', '18', '24', '48'],
    correctIndex: 2,
    explanation: '6 = 2×3, 8 = 2×2×2, sehingga KPK = 2×2×2×3 = 24.',
  ),
  Question(
    id: 'b4',
    moduleId: 'mod2',
    text: 'FPB dari 24 dan 36 adalah',
    options: ['4', '6', '8', '12'],
    correctIndex: 3,
    explanation: 'Faktor persekutuan terbesar dari 24 dan 36 adalah 12.',
  ),
  Question(
    id: 'b5',
    moduleId: 'mod3',
    text: '1/2 + 1/3 =',
    options: ['1/5', '5/6', '2/5', '7/6'],
    correctIndex: 1,
    explanation: '1/2 + 1/3 = 3/6 + 2/6 = 5/6.',
  ),
  Question(
    id: 'b6',
    moduleId: 'mod3',
    text: '3/4 - 1/8 =',
    options: ['2/8', '5/8', '1/2', '7/8'],
    correctIndex: 3,
    explanation: '3/4 = 6/8 sehingga 6/8 − 1/8 = 5/8.',
  ),
  Question(
    id: 'b7',
    moduleId: 'mod4',
    text: '2x + 3 = 11, nilai x adalah',
    options: ['2', '3', '4', '5'],
    correctIndex: 2,
    explanation: '2x + 3 = 11 sehingga 2x = 8 dan x = 4.',
  ),
  Question(
    id: 'b8',
    moduleId: 'mod4',
    text: '5x - 7 = 18, nilai x adalah',
    options: ['3', '4', '5', '6'],
    correctIndex: 2,
    explanation: '5x − 7 = 18 sehingga 5x = 25 dan x = 5.',
  ),
  Question(
    id: 'b9',
    moduleId: 'mod5',
    text: 'Luas persegi dengan sisi 6 cm adalah',
    options: ['12 cm²', '18 cm²', '24 cm²', '36 cm²'],
    correctIndex: 3,
    explanation: 'Luas persegi = sisi × sisi = 6 × 6 = 36 cm².',
  ),
];

const List<Question> kUjiQuestions = [
  Question(
    id: 'u1',
    moduleId: 'mod1',
    text: 'Hasil dari −9 + 4 adalah',
    options: ['−13', '−5', '5', '13'],
    correctIndex: 1,
    explanation: '',
  ),
  Question(
    id: 'u2',
    moduleId: 'mod1',
    text: 'Hasil dari 6 − (−2) adalah',
    options: ['4', '6', '8', '−8'],
    correctIndex: 2,
    explanation: '',
  ),
  Question(
    id: 'u3',
    moduleId: 'mod2',
    text: 'KPK dari 4 dan 10 adalah',
    options: ['10', '12', '18', '20'],
    correctIndex: 3,
    explanation: '',
  ),
  Question(
    id: 'u4',
    moduleId: 'mod3',
    text: '2/3 + 1/6 =',
    options: ['1/2', '5/6', '3/6', '7/6'],
    correctIndex: 1,
    explanation: '',
  ),
  Question(
    id: 'u5',
    moduleId: 'mod4',
    text: '3x + 5 = 14, nilai x adalah',
    options: ['3', '4', '5', '6'],
    correctIndex: 0,
    explanation: '',
  ),
  Question(
    id: 'u6',
    moduleId: 'mod5',
    text: 'Keliling persegi panjang 5 cm × 7 cm adalah',
    options: ['10 cm', '12 cm', '24 cm', '26 cm'],
    correctIndex: 3,
    explanation: '',
  ),
];
