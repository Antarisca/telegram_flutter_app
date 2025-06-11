    // --- File: lib/pages/status_feed_page.dart ---
    // Lokasi: TELEGRAM1/lib/pages/status_feed_page.dart

    import 'package:flutter/material.dart';
    import 'package:http/http.dart' as http;
    import 'dart:convert';
    import 'package:TELEGRAM1/models/status.dart'; // Impor model Status (pastikan di lib/models/)
    import 'package:TELEGRAM1/pages/status_upload_page.dart'; // Impor halaman StatusUploadPage

    class StatusFeedPage extends StatefulWidget {
      const StatusFeedPage({Key? key}) : super(key: key);

      @override
      State<StatusFeedPage> createState() => _StatusFeedPageState();
    }

    class _StatusFeedPageState extends State<StatusFeedPage> {
      List<Status> _statuses = [];
      bool _isLoading = true;
      // --- PENTING: SESUAIKAN URL INI UNTUK PENGUJIAN LOKAL ---
      // Jika Anda menguji di emulator atau browser di komputer yang sama dengan XAMPP:
      // 'http://localhost/telegram_app/api_status.php'
      // Jika Anda menguji di perangkat fisik Android/iOS dan XAMPP di komputer:
      // Ganti 'localhost' dengan IP lokal komputer Anda (misal: 'http://192.168.1.100/telegram_app/api_status.php')
      final String _apiStatusUrl = 'http://localhost/telegram_app/api_status.php';

      @override
      void initState() {
        super.initState();
        _fetchStatuses(); // Muat status saat halaman pertama kali dibuka
      }

      // Fungsi untuk mengambil daftar status dari API
      Future<void> _fetchStatuses() async {
        setState(() {
          _isLoading = true; // Set loading state
        });
        try {
          final response = await http.get(Uri.parse(_apiStatusUrl));

          if (response.statusCode == 200) {
            final dynamic responseBody = jsonDecode(response.body);
            // Cek jika respons adalah pesan 'Tidak ada status ditemukan.'
            if (responseBody is Map && responseBody.containsKey('message')) {
                setState(() {
                    _statuses = []; // Kosongkan daftar status jika tidak ada
                });
            } else if (responseBody is List) {
                setState(() {
                    _statuses = responseBody.map((json) => Status.fromJson(json)).toList();
                });
            }
          } else {
            _showSnackBar('Gagal memuat status: ${response.statusCode}');
          }
        } catch (e) {
          _showSnackBar('Terjadi kesalahan jaringan: $e');
          print('Error fetching statuses: $e');
        } finally {
          setState(() {
            _isLoading = false; // Hentikan loading state
          });
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
          appBar: AppBar(
            title: const Text('Feed Status Pengguna'),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _fetchStatuses, // Tombol refresh
              ),
            ],
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator()) // Tampilkan loading
              : _statuses.isEmpty
                      ? const Center(child: Text('Belum ada status yang tersedia.')) // Tampilkan pesan jika kosong
                      : ListView.builder(
                          itemCount: _statuses.length,
                          itemBuilder: (context, index) {
                            final status = _statuses[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                              elevation: 2,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.blue.shade100,
                                          child: Text(
                                            status.username != null && status.username!.isNotEmpty
                                                ? status.username![0].toUpperCase()
                                                : '?',
                                            style: TextStyle(color: Colors.blue.shade800, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            status.username ?? 'Pengguna ${status.userId}', // Tampilkan username atau ID
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                          ),
                                        ),
                                        Text(
                                          status.timestamp,
                                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    // Menampilkan gambar jika ada
                                    if (status.imageUrl != null && status.imageUrl!.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 8.0),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(8),
                                          child: Image.network(
                                            status.imageUrl!,
                                            width: double.infinity,
                                            height: 200,
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child, loadingProgress) {
                                              if (loadingProgress == null) return child;
                                              return Center(
                                                child: CircularProgressIndicator(
                                                  value: loadingProgress.expectedTotalBytes != null
                                                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                                      : null,
                                                ),
                                              );
                                            },
                                            errorBuilder: (context, error, stackTrace) {
                                              return Container(
                                                height: 200,
                                                color: Colors.grey.shade200,
                                                child: const Center(
                                                  child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    Text(status.content, style: const TextStyle(fontSize: 14)),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  // Asumsi ID pengguna yang sedang login adalah 1.
                  // Anda perlu mengganti ini dengan ID pengguna yang sebenarnya dari sistem login Anda.
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StatusUploadPage(currentUserId: 1)), 
                  ).then((_) => _fetchStatuses()); // Refresh feed setelah kembali dari halaman upload
                },
                child: const Icon(Icons.add),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            );
          }
        }
    