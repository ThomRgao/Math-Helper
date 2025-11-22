import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/models.dart';
import '../../services/storage_service.dart';
import '../../widgets/common_widgets.dart';

class RegisterScreen extends StatefulWidget {
  final void Function(UserData user) onRegistered;
  final void Function(bool isDark) onThemeChanged;

  const RegisterScreen({
    super.key,
    required this.onRegistered,
    required this.onThemeChanged, 
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameC = TextEditingController();
  final _emailC = TextEditingController();
  final _passC = TextEditingController();
  final _confirmC = TextEditingController();
  String _kelas = 'VII';
  String _rombel = 'A';
  bool _agree = false;
  bool _ob1 = true;
  bool _ob2 = true;

  Future<void> _doRegister() async {
    if (!_agree) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap menyetujui pernyataan penggunaan data'),
        ),
      );
      return;
    }
    if (_passC.text.trim().length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password minimal 8 karakter')),
      );
      return;
    }
    if (_passC.text != _confirmC.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Konfirmasi password tidak cocok')),
      );
      return;
    }

    final existing = await StorageService.findUserByEmail(_emailC.text.trim());
    if (existing != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email sudah terdaftar')),
      );
      return;
    }

    final user = UserData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameC.text.trim(),
      email: _emailC.text.trim(),
      password: _passC.text.trim(),
      kelas: _kelas,
      rombel: _rombel,
      role: UserRole.student,
    );
    await StorageService.upsertUser(user);
    await StorageService.addNotification(
      'Siswa baru mendaftar: ${user.name} ($_kelas $_rombel)',
    );
    widget.onRegistered(user);
    if (!mounted) return;
    Navigator.pop(context);
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
                'Register',
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: kTextColor,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Nama Lengkap',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _nameC,
                decoration: roundedInput('Nama Lengkap Anda'),
              ),
              const SizedBox(height: 16),
              Text(
                'Email Aktif Saat Ini',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _emailC,
                decoration: roundedInput('Isi Email Aktif Anda'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kelas',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          value: _kelas,
                          decoration: roundedInput('')
                              .copyWith(hintText: null, labelText: null),
                          items: const [
                            DropdownMenuItem(
                                value: 'VII', child: Text('VII')),
                            DropdownMenuItem(
                                value: 'VIII', child: Text('VIII')),
                            DropdownMenuItem(
                                value: 'IX', child: Text('IX')),
                          ],
                          onChanged: (v) {
                            setState(() {
                              _kelas = v ?? 'VII';
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rombel',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          value: _rombel,
                          decoration: roundedInput('')
                              .copyWith(hintText: null, labelText: null),
                          items: const [
                            DropdownMenuItem(value: 'A', child: Text('A')),
                            DropdownMenuItem(value: 'B', child: Text('B')),
                            DropdownMenuItem(value: 'C', child: Text('C')),
                          ],
                          onChanged: (v) {
                            setState(() {
                              _rombel = v ?? 'A';
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Password (Min 8 Character)',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _passC,
                obscureText: _ob1,
                decoration: roundedInput('Isi Password').copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _ob1
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _ob1 = !_ob1;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Confirm Password',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _confirmC,
                obscureText: _ob2,
                decoration: roundedInput('Konfirmasi Password').copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(
                      _ob2
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _ob2 = !_ob2;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _agree,
                    activeColor: kPrimaryColor,
                    onChanged: (v) {
                      setState(() {
                        _agree = v ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      'Saya menyetujui bahwa data yang saya berikan akan digunakan untuk keperluan pembuatan akun.',
                      style: GoogleFonts.poppins(fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: primaryButtonStyle(),
                  onPressed: _doRegister,
                  child: Text(
                    'Register',
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
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Have account? Login',
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
