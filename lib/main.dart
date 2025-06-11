// --- File: lib/main.dart ---
// Lokasi: TELEGRAM1/lib/main.dart

import 'package:flutter/material.dart';
// Impor halaman-halaman utama Anda dari folder 'lib'
import 'package:TELEGRAM1/qr_login_page.dart';
import 'package:TELEGRAM1/phone_login_page.dart';
import 'package:TELEGRAM1/code_verification_page.dart';
import 'package:TELEGRAM1/home_page.dart';

// Impor halaman-halaman baru yang Anda buat dari folder 'lib/pages'
import 'package:TELEGRAM1/pages/status_feed_page.dart';

void main() {
  runApp(const TelegramLoginApp());
}

class TelegramLoginApp extends StatelessWidget {
  const TelegramLoginApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Telegram Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Rute awal aplikasi saat pertama kali dibuka
      routes: {
        '/': (context) => const QrLoginPage(),
        '/phone_login': (context) => const PhoneLoginPage(),
        // PERUBAHAN DI SINI: Berikan phoneNumber dummy untuk rute awal
        '/verify_code': (context) => const CodeVerificationPage(phoneNumber: '000000000000'), // <--- PERBAIKAN UTAMA
        '/home': (context) => const HomePage(),
        '/status_feed': (context) => const StatusFeedPage(),
      },
      // Builder ini memposisikan aplikasi di tengah dengan lebar maksimum
      // Berguna untuk tampilan web di layar lebar.
      builder: (context, child) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 1400, // Lebar maksimum aplikasi Flutter Anda
              maxHeight: double.infinity, // Tinggi tidak dibatasi
            ),
            child: child,
          ),
        );
      },
    );
  }
}
