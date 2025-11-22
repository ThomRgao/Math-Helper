import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/models.dart';

Widget buildLogoLarge() {
  return Center(
    child: Padding(
      padding: const EdgeInsets.only(top: 24.0, bottom: 16),
      child: Image.asset(
        'assets/logo.png',
        height: 120,
      ),
    ),
  );
}

InputDecoration roundedInput(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[500]),
    contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: kPrimaryColor),
    ),
    filled: true,
    fillColor: Colors.white,
  );
}

ButtonStyle primaryButtonStyle() {
  return ElevatedButton.styleFrom(
    backgroundColor: kPrimaryColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    elevation: 0,
  );
}

PageRouteBuilder<T> slideRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 280),
    pageBuilder: (_, animation, __) {
      final curved =
          CurvedAnimation(parent: animation, curve: Curves.easeInOut);
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position:
              Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero)
                  .animate(curved),
          child: page,
        ),
      );
    },
  );
}
