    // --- File: lib/qr_login_page.dart ---
    // Lokasi: TELEGRAM1/lib/qr_login_page.dart

    import 'package:flutter/material.dart';

    // Halaman untuk login menggunakan QR Code.
    // Menampilkan QR code placeholder dan instruksi login.
    class QrLoginPage extends StatelessWidget {
      const QrLoginPage({super.key});

      // URL placeholder untuk QR Code.
      // Dalam implementasi nyata, QR Code ini akan dihasilkan secara dinamis oleh backend
      // dan akan berisi token atau informasi sesi untuk login.
      final String qrCodeImageUrl = 'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=https://telegram.org/login';

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.white, // Latar belakang putih
          body: Center( // Memposisikan konten di tengah layar
            child: SingleChildScrollView( // Memungkinkan konten untuk discroll jika terlalu panjang
              padding: const EdgeInsets.all(24.0), // Padding di sekitar konten
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 400, // Lebar maksimum konten agar tidak terlalu lebar di desktop
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Pusatkan secara vertikal
                  crossAxisAlignment: CrossAxisAlignment.center, // Pusatkan secara horizontal
                  children: [
                    // Judul halaman
                    const Text(
                      'Log in to Telegram by QR Code',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32), // Jarak vertikal

                    // Gambar QR Code
                    Image.network(
                      qrCodeImageUrl,
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                      // Tampilan fallback jika gambar gagal dimuat
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 200,
                          height: 200,
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: Icon(
                              Icons.qr_code_2,
                              size: 100,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      },
                      // Tampilan loading saat gambar dimuat
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return SizedBox(
                          width: 200,
                          height: 200,
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 32), // Jarak vertikal

                    // Instruksi login
                    _buildInstructionText('1. Open Telegram on your phone'),
                    _buildInstructionText('2. Go to Settings > Devices > Link Desktop Device'),
                    _buildInstructionText('3. Point your phone at this screen to confirm login'),
                    const SizedBox(height: 48), // Jarak vertikal yang lebih besar

                    // Tombol "LOG IN BY PHONE NUMBER"
                    TextButton(
                      onPressed: () {
                        // Navigasi ke halaman login telepon
                        Navigator.pushNamed(context, '/phone_login');
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.blue.shade700, // Warna teks tombol
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: const Text('LOG IN BY PHONE NUMBER'),
                    ),
                    const SizedBox(height: 24), // Jarak vertikal

                    // Tombol "LANJUTKAN DALAM BAHASA INDONESIA"
                    TextButton(
                      onPressed: () {
                        // Aksi untuk mengubah bahasa atau menampilkan pesan
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

      // Widget pembantu untuk membuat teks instruksi dengan gaya yang konsisten
      Widget _buildInstructionText(String text) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade700,
            ),
            textAlign: TextAlign.center,
          ),
        );
      }
    }
    