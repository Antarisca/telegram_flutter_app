    // --- File: lib/pages/status_upload_page.dart ---
    // Lokasi: TELEGRAM1/lib/pages/status_upload_page.dart

    import 'package:flutter/material.dart';
    import 'package:http/http.dart' as http;
    import 'dart:convert'; // Untuk jsonEncode dan jsonDecode
    import 'dart:io'; // Untuk File
    import 'package:image_picker/image_picker.dart'; // Untuk memilih gambar dari galeri/kamera
    import 'package:TELEGRAM1/models/status.dart'; // Impor model Status

    class StatusUploadPage extends StatefulWidget {
      // Kita akan meneruskan ID pengguna yang sedang login ke halaman ini
      final int currentUserId;
      const StatusUploadPage({Key? key, required this.currentUserId}) : super(key: key);

      @override
      State<StatusUploadPage> createState() => _StatusUploadPageState();
    }

    class _StatusUploadPageState extends State<StatusUploadPage> {
      final TextEditingController _statusController = TextEditingController();
      
      // --- PENTING: SESUAIKAN URL INI UNTUK PENGUJIAN LOKAL ---
      // Jika Anda menguji di emulator atau browser di komputer yang sama dengan XAMPP:
      // 'http://localhost/telegram_app/api_status.php'
      // Jika Anda menguji di perangkat fisik Android/iOS dan XAMPP di komputer:
      // Ganti 'localhost' dengan IP lokal komputer Anda (misal: 'http://192.168.1.100/telegram_app/api_status.php')
      final String _apiStatusUrl = 'http://localhost/telegram_app/api_status.php';
      final String _apiUploadImageUrl = 'http://localhost/telegram_app/upload_image.php';

      File? _selectedImage; // Untuk menyimpan gambar yang dipilih

      @override
      void dispose() {
        _statusController.dispose();
        super.dispose();
      }

      // Fungsi untuk memilih gambar dari galeri
      Future<void> _pickImage() async {
        final picker = ImagePicker();
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);

        if (pickedFile != null) {
          setState(() {
            _selectedImage = File(pickedFile.path);
          });
        }
      }

      // Fungsi untuk mengunggah gambar ke server PHP
      Future<String?> _uploadImageToServer(File imageFile) async {
        try {
          var request = http.MultipartRequest('POST', Uri.parse(_apiUploadImageUrl));
          // Menambahkan file gambar ke request
          request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

          var response = await request.send(); // Mengirim request
          if (response.statusCode == 200) {
            final responseData = jsonDecode(await response.stream.bytesToString());
            if (responseData['image_url'] != null) {
              return responseData['image_url']; // Mengembalikan URL gambar yang diunggah
            } else {
              _showSnackBar(responseData['message'] ?? 'Gagal mendapatkan URL gambar.');
              return null;
            }
          } else {
            _showSnackBar('Gagal mengunggah gambar: ${response.statusCode}');
            return null;
          }
        } catch (e) {
          _showSnackBar('Error upload gambar: $e');
          print('Error uploading image: $e');
          return null;
        }
      }

      // Fungsi utama untuk mengunggah status (teks dan/atau gambar)
      Future<void> _uploadStatus() async {
        if (_statusController.text.isEmpty && _selectedImage == null) {
          _showSnackBar('Status tidak boleh kosong dan/atau pilih gambar!');
          return;
        }

        String? uploadedImageUrl;
        if (_selectedImage != null) {
          _showSnackBar('Mengunggah gambar...');
          uploadedImageUrl = await _uploadImageToServer(_selectedImage!);
          if (uploadedImageUrl == null) {
            return; // Jika gagal mengunggah gambar, hentikan proses
          }
        }

        try {
          final response = await http.post(
            Uri.parse(_apiStatusUrl),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8', // Beri tahu server bahwa body adalah JSON
            },
            body: jsonEncode(<String, dynamic>{
              'user_id': widget.currentUserId, // Menggunakan ID pengguna yang sedang login
              'content': _statusController.text,
              'image_url': uploadedImageUrl, // Kirim URL gambar yang sudah diunggah (bisa null)
            }),
          );

          if (response.statusCode == 200) {
            final Map<String, dynamic> responseData = jsonDecode(response.body);
            _showSnackBar(responseData['message'] ?? 'Status berhasil diunggah!');
            _statusController.clear(); // Bersihkan input teks
            setState(() {
              _selectedImage = null; // Bersihkan gambar yang dipilih
            });
            Navigator.pop(context); // Kembali ke halaman sebelumnya (Feed Status)
          } else {
            final Map<String, dynamic> errorData = jsonDecode(response.body);
            _showSnackBar('Gagal mengunggah status: ${errorData['message']} (Code: ${response.statusCode})');
          }
        } catch (e) {
          _showSnackBar('Terjadi kesalahan jaringan: $e');
          print('Error uploading status: $e');
        }
      }

      // Fungsi pembantu untuk menampilkan SnackBar
      void _showSnackBar(String message) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Unggah Status Baru'),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _statusController,
                  decoration: const InputDecoration(
                    labelText: 'Tulis status Anda...',
                    hintText: 'Bagikan pemikiran atau aktivitas Anda...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 5,
                  minLines: 3,
                ),
                const SizedBox(height: 16),
                // Menampilkan gambar yang dipilih jika ada
                _selectedImage != null
                    ? Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: FileImage(_selectedImage!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(), // Jika tidak ada gambar, tampilkan widget kosong
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text('Pilih Gambar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade100,
                    foregroundColor: Colors.blue.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _uploadStatus,
                  child: const Text('Unggah Status'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }
    