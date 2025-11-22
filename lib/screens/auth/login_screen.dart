import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/models.dart';
import '../../services/storage_service.dart';
import '../../widgets/common_widgets.dart';
import '../student/student_home_screen.dart';
import '../admin/admin_home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  final void Function(UserData user, bool keepSignedIn) onLogin;
  final void Function(bool isDark) onThemeChanged;

  const LoginScreen({
    super.key,
    required this.onLogin,
    required this.onThemeChanged,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailC = TextEditingController();
  final _passC = TextEditingController();
  bool _keep = false;
  bool _obscure = true;

  Future<void> _doLogin() async {
    final email = _emailC.text.trim();
    final pass = _passC.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan password wajib diisi')),
      );
      return;
    }

    if (email == 'admin' && pass == 'admin') {
      final admin = UserData(
        id: 'admin',
        name: 'Admin',
        email: 'admin',
        password: 'admin',
        kelas: '-',
        rombel: '-',
        role: UserRole.admin,
      );
      await StorageService.upsertUser(admin);
      widget.onLogin(admin, _keep);
      Navigator.of(context).pushAndRemoveUntil(
        slideRoute(AdminHomeScreen(user: admin, onLogout: () {})),
        (route) => false,
      );
      return;
    }

    final user = await StorageService.findUserByEmail(email);
    if (user == null || user.password != pass) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email atau password salah')),
      );
      return;
    }

    await StorageService.addNotification(
      'Siswa ${user.name} melakukan login.',
    );
    widget.onLogin(user, _keep);

    Navigator.of(context).pushAndRemoveUntil(
      slideRoute(
        user.role == UserRole.admin
            ? AdminHomeScreen(user: user, onLogout: () {})
            : StudentHomeScreen(user: user, onLogout: () {}),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildLogoLarge(),
              const SizedBox(height: 8),
              Text(
                'Sign in',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: kTextColor,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Email',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _emailC,
                decoration: roundedInput('Isi Email Anda'),
              ),
              const SizedBox(height: 16),
              Text(
                'Password',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _passC,
                obscureText: _obscure,
                decoration: roundedInput('Isi Password Anda').copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscure = !_obscure;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Checkbox(
                          value: _keep,
                          activeColor: kPrimaryColor,
                          onChanged: (v) {
                            setState(() {
                              _keep = v ?? false;
                            });
                          },
                        ),
                        Text(
                          'Keep me signed in',
                          style: GoogleFonts.poppins(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Hubungi admin untuk mengatur ulang password.',
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Forgot Password?',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: primaryButtonStyle(),
                  onPressed: _doLogin,
                  child: Text(
                    'Sign in',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      slideRoute(
                        RegisterScreen(
                          onRegistered: (user) {
                            _emailC.text = user.email;
                          },
                          onThemeChanged: widget.onThemeChanged, 
                        ),
                      ),
                    );
                  },
                  child: Text(
                    "Don’t have any account yet?",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Mode gelap',
                    style: GoogleFonts.poppins(fontSize: 12),
                  ),
                  const SizedBox(width: 8),
                  Switch(
                    value: isDark,
                    activeColor: kPrimaryColor,
                    onChanged: widget.onThemeChanged,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
