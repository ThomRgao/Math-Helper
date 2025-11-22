import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xFF0066FF);
const kBackgroundColor = Color(0xFFF7F9FC);
const kTextColor = Color(0xFF1F2933);
const double kDefaultPadding = 20.0;

Route<T> slideRoute<T>(Widget page) {
  return PageRouteBuilder<T>(
    pageBuilder: (_, __, ___) => page,
    transitionsBuilder: (_, animation, __, child) {
      final offsetAnimation = Tween<Offset>(
        begin: const Offset(0.1, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: animation, curve: Curves.easeOut),
      );
      return SlideTransition(
        position: offsetAnimation,
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    },
  );
}

InputDecoration roundedInput(String hint) {
  return InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: kPrimaryColor, width: 1.4),
    ),
  );
}

ButtonStyle primaryButtonStyle() {
  return ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 2,
    backgroundColor: kPrimaryColor,
  );
}

Widget buildLogoLarge() {
  return Center(
    child: Column(
      children: [
        Container(
          width: 110,
          height: 110,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Image.asset('assets/Logo.png', fit: BoxFit.contain),
        ),
        const SizedBox(height: 12),
      ],
    ),
  );
}

Widget buildLogoSmall() {
  return Row(
    children: [
      Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(6),
        child: Image.asset('assets/Logo.png', fit: BoxFit.contain),
      ),
      const SizedBox(width: 12),
      const Text(
        'Math Helper SMP',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: kTextColor,
        ),
      ),
    ],
  );
}
