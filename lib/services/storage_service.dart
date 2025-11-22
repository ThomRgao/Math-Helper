import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/models.dart';

class StorageService {
  static const _usersKey = 'users';
  static const _historyKey = 'history';
  static const _notificationsKey = 'admin_notifications';
  static const _resourcesKey = 'module_resources';
  static const _currentUserIdKey = 'current_user_id';
  static const _keepSignedInKey = 'keep_signed_in';

  static Future<List<UserData>> loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_usersKey);
    if (jsonStr == null || jsonStr.isEmpty) return [];
    final List list = json.decode(jsonStr);
    return list.map((e) => UserData.fromJson(e)).toList();
  }

  static Future<void> saveUsers(List<UserData> users) async {
    final prefs = await SharedPreferences.getInstance();
    final list = users.map((e) => e.toJson()).toList();
    await prefs.setString(_usersKey, json.encode(list));
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

  static Future<void> upsertUser(UserData user) async {
    final users = await loadUsers();
    final index = users.indexWhere((u) => u.id == user.id);
    if (index >= 0) {
      users[index] = user;
    } else {
      users.add(user);
    }
    await saveUsers(users);
  }

  static Future<void> resetUserPassword(String userId, String newPassword) async {
    final users = await loadUsers();
    final index = users.indexWhere((u) => u.id == userId);
    if (index >= 0) {
      final u = users[index];
      users[index] = UserData(
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

  static Future<void> setCurrentUser(String? id, {bool keepSignedIn = false}) async {
    final prefs = await SharedPreferences.getInstance();
    if (id == null) {
      await prefs.remove(_currentUserIdKey);
      await prefs.setBool(_keepSignedInKey, false);
    } else {
      await prefs.setString(_currentUserIdKey, id);
      await prefs.setBool(_keepSignedInKey, keepSignedIn);
    }
  }

  static Future<UserData?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final keep = prefs.getBool(_keepSignedInKey) ?? false;
    if (!keep) return null;
    final id = prefs.getString(_currentUserIdKey);
    if (id == null) return null;
    final users = await loadUsers();
    try {
      return users.firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }

  static Future<List<QuizHistoryItem>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_historyKey);
    if (jsonStr == null || jsonStr.isEmpty) return [];
    final List list = json.decode(jsonStr);
    return list.map((e) => QuizHistoryItem.fromJson(e)).toList();
  }

  static Future<void> addHistory(QuizHistoryItem item) async {
    final list = await loadHistory();
    list.add(item);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _historyKey,
      json.encode(list.map((e) => e.toJson()).toList()),
    );
  }

  static Future<List<AdminNotification>> loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_notificationsKey);
    if (jsonStr == null || jsonStr.isEmpty) return [];
    final List list = json.decode(jsonStr);
    return list.map((e) => AdminNotification.fromJson(e)).toList();
  }

  static Future<void> addNotification(String message) async {
    final list = await loadNotifications();
    list.add(AdminNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: message,
      dateTime: DateTime.now(),
    ));
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _notificationsKey,
      json.encode(list.map((e) => e.toJson()).toList()),
    );
  }
  static Future<Map<String, List<String>>> loadModuleResources() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_resourcesKey);
    if (jsonStr == null || jsonStr.isEmpty) return {};
    final Map<String, dynamic> map = json.decode(jsonStr);
    return map.map((key, value) =>
        MapEntry(key, (value as List).map((e) => e.toString()).toList()));
  }

  static Future<void> saveModuleResources(
      Map<String, List<String>> resources) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_resourcesKey, json.encode(resources));
  }
}
