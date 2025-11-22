import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'models/models.dart';
import 'services/storage_service.dart';
import 'screens/auth/login_screen.dart';
import 'screens/student/student_home_screen.dart';
import 'screens/admin/admin_home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MathHelperApp());
}

class MathHelperApp extends StatefulWidget {
  const MathHelperApp({super.key});

  @override
  State<MathHelperApp> createState() => _MathHelperAppState();
}

class _MathHelperAppState extends State<MathHelperApp> {
  ThemeMode _mode = ThemeMode.light;
  bool _initialized = false;
  UserData? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadInitial();
  }

  Future<void> _loadInitial() async {
    final user = await StorageService.getCurrentUser();
    setState(() {
      _currentUser = user;
      _initialized = true;
    });
  }

  void _updateTheme(bool isDark) {
    setState(() {
      _mode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _onLogin(UserData user, bool keepSignedIn) {
    StorageService.setCurrentUser(user.id, keepSignedIn: keepSignedIn);
    setState(() {
      _currentUser = user;
    });
  }

  void _logout() {
    StorageService.setCurrentUser(null);
    setState(() {
      _currentUser = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: kBackgroundColor,
          body: const Center(
            child: CircularProgressIndicator(color: kPrimaryColor),
          ),
        ),
      );
    }

    Widget home;
    if (_currentUser == null) {
      home = LoginScreen(onLogin: _onLogin, onThemeChanged: _updateTheme);
    } else if (_currentUser!.role == UserRole.admin) {
      home = AdminHomeScreen(user: _currentUser!, onLogout: _logout);
    } else {
      home = StudentHomeScreen(user: _currentUser!, onLogout: _logout);
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _mode,
      theme: ThemeData(
        scaffoldBackgroundColor: kBackgroundColor,
        textTheme: GoogleFonts.poppinsTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: kPrimaryColor,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        textTheme:
            GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
        colorScheme: ColorScheme.fromSeed(
          seedColor: kPrimaryColor,
          brightness: Brightness.dark,
        ),
      ),
      home: home,
    );
  }
}
