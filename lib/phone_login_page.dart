// --- File: lib/phone_login_page.dart ---
// Lokasi: TELEGRAM1/lib/phone_login_page.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import for HTTP requests
import 'dart:convert'; // Import for JSON encoding/decoding
import 'package:TELEGRAM1/code_verification_page.dart'; // <<<--- BARIS INI YANG HILANG DAN DITAMBAHKAN!

// Halaman untuk login menggunakan nomor telepon dengan tampilan baru.
class PhoneLoginPage extends StatefulWidget {
  const PhoneLoginPage({super.key});

  @override
  State<PhoneLoginPage> createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage> {
  // Variabel untuk menyimpan negara yang dipilih
  String? _selectedCountry = 'Indonesia'; // Default negara
  final TextEditingController _phoneNumberController = TextEditingController();

  // --- PENTING: SESUAIKAN URL INI UNTUK PENGUJIAN LOKAL ---
  // Jika Anda menguji di emulator atau browser di komputer yang sama dengan XAMPP:
  // 'http://localhost/telegram_app/api_login.php'
  // Jika Anda menguji di perangkat fisik Android/iOS dan XAMPP di komputer:
  // Ganti 'localhost' dengan IP lokal komputer Anda (misal: 'http://192.168.1.100/telegram_app/api_login.php')
  final String _apiLoginUrl = 'http://localhost/telegram_app/api_login.php';

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  // Fungsi untuk meminta kode verifikasi dari backend
  Future<void> _requestCode() async {
    final String fullPhoneNumber = '+62${_phoneNumberController.text.trim()}'; // Gabungkan dengan kode negara

    if (_phoneNumberController.text.isEmpty) {
      _showSnackBar('Nomor telepon tidak boleh kosong.');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(_apiLoginUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'mode': 'request_code', // Mode untuk meminta kode
          'phone_number': fullPhoneNumber,
        }),
      );

      // --- DEBUGGING TAMBAHAN ---
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      // --- END DEBUGGING ---

      // Periksa apakah body respons kosong sebelum mencoba decode
      if (response.body.isEmpty) {
        _showSnackBar('Respons dari server kosong.');
        return;
      }

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        _showSnackBar(responseData['message'] ?? 'Kode verifikasi berhasil diminta.');
        // Navigasi ke halaman verifikasi kode dan kirim nomor teleponnya
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CodeVerificationPage(phoneNumber: fullPhoneNumber),
          ),
        );
      } else {
        _showSnackBar(responseData['message'] ?? 'Gagal meminta kode verifikasi.');
      }
    } catch (e) {
      _showSnackBar('Terjadi kesalahan jaringan atau respons tidak valid: $e');
      print('Error requesting code: $e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang putih
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 400, // Lebar maksimum konten agar tidak terlalu lebar di desktop
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center, // Pusatkan secara horizontal
              children: [
                // Logo Telegram (biru dengan ikon pesawat kertas)
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.blue.shade600,
                  child: const Icon(
                    Icons.send, // Ikon pesawat kertas
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 24), // Jarak vertikal

                // Judul "Sign in to Telegram"
                const Text(
                  'Sign in to Telegram',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16), // Jarak vertikal

                // Subtitle
                const Text(
                  'Please confirm your country code\nand enter your phone number.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32), // Jarak vertikal

                // Dropdown untuk memilih Negara
                DropdownButtonFormField<String>(
                  value: _selectedCountry,
                  decoration: InputDecoration(
                    labelText: 'Country',
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    floatingLabelBehavior: FloatingLabelBehavior.always, // Label selalu di atas
                  ),
                  items: <String>['Indonesia', 'United States', 'India', 'Germany', 'France']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCountry = newValue;
                    });
                  },
                ),
                const SizedBox(height: 16), // Jarak vertikal

                // Input Nomor Telepon
                TextField(
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    hintText: '812 3456 7890', // Hanya bagian setelah +62
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    prefixText: '+62 ', // Prefix +62
                    prefixStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    floatingLabelBehavior: FloatingLabelBehavior.always, // Label selalu di atas
                  ),
                ),
                const SizedBox(height: 32), // Jarak vertikal

                // Tombol "NEXT"
                ElevatedButton(
                  onPressed: _requestCode, // Panggil fungsi untuk meminta kode
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600, // Warna biru yang konsisten
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8), // Sudut sedikit membulat
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Text('NEXT'),
                ),
                
                const SizedBox(height: 20), // Jarak vertikal antara tombol NEXT dan LOG IN BY QR CODE

                // Tombol "LOG IN BY QR CODE"
                TextButton(
                  onPressed: () {
                    // Navigasi kembali ke halaman QR Login
                    Navigator.pop(context); 
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue.shade700, // Warna teks tombol
                    textStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  child: const Text('LOG IN BY QR CODE'),
                ),
                const SizedBox(height: 10), // Jarak antar link

                // Tombol "LANJUTKAN DALAM BAHASA INDONESIA"
                TextButton(
                  onPressed: () {
                    // Aksi untuk mengubah bahasa ke Bahasa Indonesia (jika belum)
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Mengubah bahasa ke Bahasa Indonesia...')),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue.shade700, // Warna teks tombol
                    textStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  child: const Text('LANJUTKAN DALAM BAHASA INDONESIA'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
