import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/models.dart';

class ProfileScreen extends StatelessWidget {
  final UserData user;
  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 32,
                backgroundColor: kPrimaryColor,
                child: Icon(Icons.person, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name,
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.w600)),
                  Text('${user.kelas} ${user.rombel}',
                      style: GoogleFonts.poppins(
                          fontSize: 13, color: Colors.grey[700])),
                  Text(user.email,
                      style: GoogleFonts.poppins(
                          fontSize: 12, color: Colors.grey[700])),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text('Pengaturan Akun',
              style: GoogleFonts.poppins(
                  fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.lock_outline),
            title: Text('Ganti Password',
                style: GoogleFonts.poppins(fontSize: 14)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Fitur ganti password disederhanakan.')));
            },
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.logout),
            title: Text('Logout',
                style: GoogleFonts.poppins(fontSize: 14)),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
