import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For FilteringTextInputFormatter
import 'package:http/http.dart' as http; // Import for HTTP requests
import 'dart:convert'; // Import for JSON encoding/decoding
import 'package:TELEGRAM1/home_page.dart'; // Import home_page.dart for navigation (pastikan file ini ada)

// Halaman untuk verifikasi kode yang dikirim ke nomor telepon.
class CodeVerificationPage extends StatefulWidget {
  final String phoneNumber; // Menerima nomor telepon dari halaman sebelumnya

  // Konstruktor wajib menerima phoneNumber
  const CodeVerificationPage({super.key, required this.phoneNumber});

  @override
  State<CodeVerificationPage> createState() => _CodeVerificationPageState();
}

class _CodeVerificationPageState extends State<CodeVerificationPage> {
  final TextEditingController _codeController = TextEditingController();

  // --- PENTING: SESUAIKAN URL INI UNTUK PENGUJIAN LOKAL ---
  // URL ini harus sama persis dengan yang ada di PhoneLoginPage dan PHP API Anda.
  final String _apiLoginUrl = 'http://localhost/telegram_app/api_login.php';

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  // Fungsi untuk memverifikasi kode dengan backend
  Future<void> _verifyCode() async {
    final String code = _codeController.text.trim(); // Ambil kode dan hapus spasi

    // Validasi dasar: Pastikan kode tidak kosong
    if (code.isEmpty) {
      _showSnackBar('Kode verifikasi tidak boleh kosong.');
      return;
    }

    try {
      print('Sending verification request for phone: ${widget.phoneNumber}, code: $code'); // Debugging
      final response = await http.post(
        Uri.parse(_apiLoginUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'mode': 'verify_code', // Mode untuk verifikasi kode
          'phone_number': widget.phoneNumber, // Gunakan nomor telepon yang diterima
          'code': code, // Kode yang dimasukkan pengguna
        }),
      );

      // --- DEBUGGING TAMBAHAN ---
      print('Verification Status Code: ${response.statusCode}');
      print('Verification Response Body: ${response.body}');
      // --- END DEBUGGING ---

      // Periksa jika respons body kosong
      if (response.body.isEmpty) {
        _showSnackBar('Respons dari server kosong.');
        return;
      }

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      // LOGIKA KUNCI: Verifikasi berdasarkan flag 'success' dari respons JSON PHP
      if (responseData['success'] == true) {
        _showSnackBar(responseData['message'] ?? 'Verifikasi berhasil!');
        // Jika verifikasi berhasil, navigasi ke halaman utama
        // Menggunakan MaterialPageRoute untuk konsistensi dengan push pada PhoneLoginPage,
        // dan menghindari masalah named routes jika tidak dikonfigurasi dengan benar di main.dart.
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()), // Navigasi ke HomePage
          (Route<dynamic> route) => false, // Hapus semua rute sebelumnya dari stack navigasi
        );
      } else {
        // Jika verifikasi gagal (success: false dari PHP), tampilkan pesan error dari server
        _showSnackBar(responseData['message'] ?? 'Verifikasi gagal. Silakan coba lagi.');
      }
    } catch (e) {
      // Tangani kesalahan jaringan atau parsing JSON
      _showSnackBar('Terjadi kesalahan jaringan atau respons tidak valid: $e');
      print('Error verifying code: $e'); // Log error untuk debugging
    }
  }

  // Fungsi untuk menampilkan SnackBar
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
                // Ikon emoji monyet (sesuai dengan gambar yang Anda berikan)
                const Text(
                  '🐵', // Monkey emoji
                  style: TextStyle(fontSize: 80),
                ),
                const SizedBox(height: 16), // Jarak vertikal

                // Nomor telepon dengan ikon edit (gunakan widget.phoneNumber)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.phoneNumber, // Tampilkan nomor telepon yang diterima
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(width: 8),
                    // Tombol edit untuk kembali ke halaman login telepon
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20, color: Colors.blue),
                      onPressed: () {
                        // Kembali ke halaman sebelumnya (PhoneLoginPage)
                        Navigator.pop(context); 
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16), // Jarak vertikal

                // Teks instruksi
                const Text(
                  'Kami telah mengirimkan pesan di Telegram\ndengan kode verifikasi.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32), // Jarak vertikal

                // Field input kode verifikasi
                TextField(
                  controller: _codeController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 6, // Kode verifikasi umumnya 6 digit
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly, // Hanya izinkan angka
                  ],
                  decoration: InputDecoration(
                    labelText: 'Kode', // Label 'Code'
                    hintText: 'XXXXXX',
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)), // Sudut membulat
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    floatingLabelBehavior: FloatingLabelBehavior.always, // Label selalu di atas
                    counterText: '', // Sembunyikan penghitung karakter (0/6)
                  ),
                ),
                const SizedBox(height: 32), // Jarak vertikal

                // Tombol "NEXT" (untuk memverifikasi)
                ElevatedButton(
                  onPressed: _verifyCode, // Panggil fungsi untuk memverifikasi kode
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
                const SizedBox(height: 10), // Jarak vertikal

                // Tombol "KIRIM ULANG KODE"
                TextButton(
                  onPressed: () {
                    // Aksi untuk mengirim ulang kode
                    _showSnackBar('Mengirim ulang kode... (fitur ini memerlukan implementasi ulang request_code ke backend)');
                    // Dalam implementasi nyata, Anda akan memanggil kembali _requestCode()
                    // atau API serupa dari PhoneLoginPage jika memungkinkan,
                    // atau membuat fungsi baru untuk request ulang kode saja.
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue.shade700, // Warna teks tombol biru
                    textStyle: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  child: const Text('KIRIM ULANG KODE'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
