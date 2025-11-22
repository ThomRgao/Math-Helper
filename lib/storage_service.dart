import 'package:shared_preferences/shared_preferences.dart';

import 'models.dart';

class StorageService {
  static const _keyUsers = 'users';
  static const _keyCurrentUserId = 'current_user_id';
  static const _keyModules = 'modules';
  static const _keyQuestions = 'questions';
  static const _keyHistory = 'quiz_history';
  static const _keyNotifications = 'admin_notifications';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<SharedPreferences> _ensurePrefs() async {
    if (_prefs != null) return _prefs!;
    _prefs = await SharedPreferences.getInstance();
    return _prefs!;
  }


  static Future<List<UserData>> loadUsers() async {
    final prefs = await _ensurePrefs();
    final src = prefs.getString(_keyUsers);
    final list = decodeList(src);
    return list.map(UserData.fromJson).toList();
  }

  static Future<void> saveUsers(List<UserData> users) async {
    final prefs = await _ensurePrefs();
    final list = users.map((e) => e.toJson()).toList();
    await prefs.setString(_keyUsers, encodeList(list));
  }

  static Future<void> upsertUser(UserData user) async {
    final users = await loadUsers();
    final idx = users.indexWhere((u) => u.id == user.id);
    if (idx >= 0) {
      users[idx] = user;
    } else {
      users.add(user);
    }
    await saveUsers(users);
  }

  static Future<UserData?> findUserByEmail(String email) async {
    final users = await loadUsers();
    try {
      return users.firstWhere(
          (u) => u.email.toLowerCase() == email.toLowerCase());
    } catch (_) {
      return null;
    }
  }

  static Future<void> resetUserPassword(String userId, String newPassword) async {
    final users = await loadUsers();
    final idx = users.indexWhere((u) => u.id == userId);
    if (idx >= 0) {
      final u = users[idx];
      users[idx] = UserData(
        id: u.id,
        name: u.name,
        email: u.email,
        password: newPassword,
        kelas: u.kelas,
        rombel: u.rombel,
        role: u.role,
      );
      await saveUsers(users);
    }
  }

  static Future<void> setCurrentUser(String? id,
      {bool keepSignedIn = true}) async {
    final prefs = await _ensurePrefs();
    if (id == null) {
      await prefs.remove(_keyCurrentUserId);
    } else {
      await prefs.setString(_keyCurrentUserId, id);
    }
  }

  static Future<UserData?> getCurrentUser() async {
    final prefs = await _ensurePrefs();
    final id = prefs.getString(_keyCurrentUserId);
    if (id == null) return null;
    final users = await loadUsers();
    try {
      return users.firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }


  static Future<List<ModuleData>> loadModules() async {
    final prefs = await _ensurePrefs();
    final src = prefs.getString(_keyModules);
    final list = decodeList(src);
    if (list.isEmpty) {
      final initial = [
        ModuleData(
          id: 'm1',
          title: 'Bilangan Bulat',
          description: 'Konsep dasar bilangan bulat dan operasinya.',
          kelas: 'VII',
        ),
        ModuleData(
          id: 'm2',
          title: 'Pertidaksamaan Linear',
          description: 'Materi pertidaksamaan satu variabel.',
          kelas: 'VIII',
        ),
      ];
      await saveModules(initial);
      return initial;
    }
    return list.map(ModuleData.fromJson).toList();
  }

  static Future<void> saveModules(List<ModuleData> modules) async {
    final prefs = await _ensurePrefs();
    final list = modules.map((e) => e.toJson()).toList();
    await prefs.setString(_keyModules, encodeList(list));
  }

  static Future<void> addModule(ModuleData module) async {
    final modules = await loadModules();
    modules.add(module);
    await saveModules(modules);
  }

  static Future<void> deleteModule(String id) async {
    final modules = await loadModules();
    modules.removeWhere((m) => m.id == id);
    await saveModules(modules);
  }


  static Future<List<Question>> loadQuestions() async {
    final prefs = await _ensurePrefs();
    final src = prefs.getString(_keyQuestions);
    final list = decodeList(src);
    if (list.isEmpty) {
      final qs = <Question>[
        Question(
          id: 'q1',
          moduleId: 'm1',
          text: 'Hasil dari 5 + (-8) adalah ...',
          options: ['-13', '-3', '3', '13'],
          correctIndex: 1,
          explanation: '5 + (-8) = 5 - 8 = -3',
          kind: QuestionKind.bank,
        ),
        Question(
          id: 'q2',
          moduleId: 'm1',
          text: 'Nilai dari -4 × (-3) adalah ...',
          options: ['-12', '7', '12', '-7'],
          correctIndex: 2,
          explanation: 'Negatif × negatif = positif, 4×3 = 12',
          kind: QuestionKind.exam,
        ),
      ];
      await saveQuestions(qs);
      return qs;
    }
    return list.map(Question.fromJson).toList();
  }

  static Future<void> saveQuestions(List<Question> questions) async {
    final prefs = await _ensurePrefs();
    final list = questions.map((e) => e.toJson()).toList();
    await prefs.setString(_keyQuestions, encodeList(list));
  }

  static Future<void> addQuestion(Question q) async {
    final qs = await loadQuestions();
    qs.add(q);
    await saveQuestions(qs);
  }


  static Future<List<QuizHistoryItem>> loadHistory() async {
    final prefs = await _ensurePrefs();
    final src = prefs.getString(_keyHistory);
    final list = decodeList(src);
    return list.map(QuizHistoryItem.fromJson).toList();
  }

  static Future<void> saveHistory(List<QuizHistoryItem> items) async {
    final prefs = await _ensurePrefs();
    final list = items.map((e) => e.toJson()).toList();
    await prefs.setString(_keyHistory, encodeList(list));
  }

  static Future<void> addHistory(QuizHistoryItem item) async {
    final list = await loadHistory();
    list.add(item);
    await saveHistory(list);
  }


  static Future<List<AdminNotification>> loadNotifications() async {
    final prefs = await _ensurePrefs();
    final src = prefs.getString(_keyNotifications);
    final list = decodeList(src);
    return list.map(AdminNotification.fromJson).toList();
  }

  static Future<void> saveNotifications(
      List<AdminNotification> items) async {
    final prefs = await _ensurePrefs();
    final list = items.map((e) => e.toJson()).toList();
    await prefs.setString(_keyNotifications, encodeList(list));
  }

  static Future<void> addNotification(String message) async {
    final list = await loadNotifications();
    list.insert(
      0,
      AdminNotification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: message,
        dateTime: DateTime.now(),
        read: false,
      ),
    );
    await saveNotifications(list);
  }
}
