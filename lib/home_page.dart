// --- File: lib/home_page.dart ---
// Lokasi: TELEGRAM1/lib/home_page.dart

import 'package:flutter/material.dart';
// Impor halaman status dan chat dari folder 'lib/pages'
import 'package:TELEGRAM1/pages/status_feed_page.dart'; 
import 'package:TELEGRAM1/pages/chat_page.dart'; 

// Mengubah HomePage menjadi StatefulWidget untuk mengelola state chat yang dipilih
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // State untuk menyimpan ID dan username chat yang sedang dipilih
  int? _selectedRecipientId;
  String? _selectedRecipientUsername;

  // Fungsi simulasi untuk mendapatkan ID pengguna yang sedang login.
  // Dalam aplikasi nyata, ini akan didapatkan dari state manajemen setelah login berhasil
  int _getCurrentUserId() {
    return 1; // Asumsi user ID 1 sedang login untuk tujuan demo
  }

  @override
  Widget build(BuildContext context) {
    final int currentLoggedInUserId = _getCurrentUserId();

    return Scaffold(
      backgroundColor: Colors.white,
      // Drawer untuk menu samping
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // DrawerHeader yang dimodifikasi agar sesuai dengan gambar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              decoration: const BoxDecoration(
                color: Colors.white, // Latar belakang putih
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Avatar "hesti"
                      const CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.deepOrange,
                        backgroundImage: AssetImage('assets/images/profile.png'),
                        onBackgroundImageError: null, // Menghapus onBackgroundImageError karena AssetImage sudah const
                        child: Text(
                          'H',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                        onPressed: () {
                          // Aksi untuk membuka daftar akun
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Nama pengguna "hesti"
                  const Text(
                    'hesti',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Waktu (menggantikan "online")
                  Text(
                    '22:28', // Menggunakan teks statis "22:28" sesuai gambar
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            // Opsi "Add Account"
            ListTile(
              leading: const Icon(Icons.add_circle_outline, color: Colors.grey),
              title: const Text('Add Account'),
              onTap: () {
                Navigator.pop(context);
                print('Add Account clicked!');
              },
            ),
            // Divider antara bagian profil dan opsi lainnya
            Divider(color: Colors.grey[300], thickness: 0.5, height: 1),
            // Opsi "Saved Messages"
            ListTile(
              leading: const Icon(Icons.bookmark_border, color: Colors.grey),
              title: const Text('Saved Messages'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            // Opsi "My Stories"
            ListTile(
              leading: const Icon(Icons.history_toggle_off, color: Colors.grey),
              title: const Text('My Stories'),
              onTap: () {
                Navigator.pop(context);
                // Navigasi ke halaman Status Feed
                Navigator.pushNamed(context, '/status_feed');
              },
            ),
            // Opsi "Contacts"
            ListTile(
              leading: const Icon(Icons.person_outline, color: Colors.grey),
              title: const Text('Contacts'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined, color: Colors.grey),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            // Opsi "More" dengan ikon panah kanan
            ListTile(
              leading: const Icon(Icons.more_horiz, color: Colors.grey),
              title: const Text('More'),
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Row(
        children: [
          // Bagian kiri: Daftar chat (sidebar)
          Container(
            width: 360, // Lebar tetap untuk daftar chat
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(right: BorderSide(color: Colors.grey[200]!, width: 1)),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.menu, color: Colors.grey),
                        onPressed: () {
                          Scaffold.of(context).openDrawer(); // Membuka drawer
                        },
                        tooltip: 'Menu',
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search',
                            prefixIcon: const Icon(Icons.search, color: Colors.grey),
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      ListView(
                        children: [
                          // Daftar ChatListItem
                          ChatListItem(
                            avatarType: 'icon',
                            avatarIcon: Icons.send,
                            avatarColor: Colors.blue,
                            name: 'Telegram',
                            lastMessage: 'Kode masuk Anda: Jangan pernah...',
                            time: 'May 27',
                            unreadCount: 0,
                            isSelected: _selectedRecipientId == 2, // Terpilih jika ID 2
                            onTap: () {
                              setState(() {
                                _selectedRecipientId = 2;
                                _selectedRecipientUsername = 'Telegram';
                              });
                            },
                          ),
                          ChatListItem(
                            avatarType: 'icon',
                            avatarIcon: Icons.movie_filter,
                            avatarColor: Colors.purple,
                            name: 'FILIM DISNEY SUB INDO',
                            lastMessage: 'Moana 2 (2024)',
                            time: 'Apr 9',
                            unreadCount: 0,
                            isSelected: _selectedRecipientId == 5, // Terpilih jika ID 5
                            onTap: () {
                              setState(() {
                                _selectedRecipientId = 5;
                                _selectedRecipientUsername = 'FILIM DISNEY SUB INDO';
                              });
                            },
                          ),
                          ChatListItem(
                            avatarType: 'text',
                            avatarText: 'FG',
                            name: 'Fhilia Gaelsi',
                            lastMessage: 'Fhilia Gaelsi joined Telegram',
                            time: '12/18/2024',
                            unreadCount: 0,
                            isSelected: _selectedRecipientId == 6, // Terpilih jika ID 6
                            onTap: () {
                              setState(() {
                                _selectedRecipientId = 6;
                                _selectedRecipientUsername = 'Fhilia Gaelsi';
                              });
                            },
                          ),
                          ChatListItem(
                            avatarType: 'text',
                            avatarText: 'B',
                            name: 'Breiner',
                            lastMessage: 'Breiner joined Telegram',
                            time: '11/11/2024',
                            unreadCount: 1,
                            isSelected: _selectedRecipientId == 7, // Terpilih jika ID 7
                            onTap: () {
                              setState(() {
                                _selectedRecipientId = 7;
                                _selectedRecipientUsername = 'Breiner';
                              });
                            },
                          ),
                          ChatListItem(
                            avatarType: 'icon',
                            avatarIcon: Icons.delete_forever,
                            avatarColor: Colors.grey[600],
                            name: 'Deleted Account',
                            lastMessage: 'Deleted Account joined Telegram',
                            time: '10/10/2024',
                            unreadCount: 0,
                            isSelected: _selectedRecipientId == 8, // Terpilih jika ID 8
                            onTap: () {
                              setState(() {
                                _selectedRecipientId = 8;
                                _selectedRecipientUsername = 'Deleted Account';
                              });
                            },
                          ),
                          ChatListItem(
                            avatarType: 'text',
                            avatarText: 'NA',
                            name: 'Nurul Aini',
                            lastMessage: 'terimakasih ibuu',
                            time: '09/5/2024',
                            unreadCount: 0,
                            isSelected: _selectedRecipientId == 9, // Terpilih jika ID 9
                            onTap: () {
                              setState(() {
                                _selectedRecipientId = 9;
                                _selectedRecipientUsername = 'Nurul Aini';
                              });
                            },
                          ),
                          ChatListItem(
                            avatarType: 'text',
                            avatarText: 'E',
                            name: 'Hukum Telematika 4THDL-E',
                            lastMessage: 'Rata : P',
                            time: '07/19/2024',
                            unreadCount: 0,
                            isSelected: _selectedRecipientId == 10, // Terpilih jika ID 10
                            onTap: () {
                              setState(() {
                                _selectedRecipientId = 10;
                                _selectedRecipientUsername = 'Hukum Telematika 4THDL-E';
                              });
                            },
                          ),
                          ChatListItem(
                            avatarType: 'text',
                            avatarText: 'AS',
                            name: 'Andi Saenong',
                            lastMessage: 'https://youtu.be/8kCaE1Du1GY',
                            time: '00:00',
                            unreadCount: 0,
                            isSelected: _selectedRecipientId == 11, // Terpilih jika ID 11
                            onTap: () {
                              setState(() {
                                _selectedRecipientId = 11;
                                _selectedRecipientUsername = 'Andi Saenong';
                              });
                            },
                          ),
                        ],
                      ),
                      // Floating Action Button untuk membuat chat baru/grup
                      Positioned(
                        bottom: 16,
                        right: 16,
                        child: FloatingActionButton(
                          onPressed: () {
                            print('Tombol pensil diklik!');
                            // Aksi untuk memulai chat baru atau membuat grup
                          },
                          backgroundColor: Colors.blue,
                          child: const Icon(Icons.edit, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Bagian kanan: Menampilkan ChatPage jika chat dipilih, atau latar belakang default
          Expanded(
            child: _selectedRecipientId != null && _selectedRecipientUsername != null
                ? ChatPage(
                    currentUserId: currentLoggedInUserId,
                    recipientId: _selectedRecipientId!,
                    recipientUsername: _selectedRecipientUsername!,
                  )
                : Container(
                    color: Colors.grey[200], // Warna latar belakang default
                    child: Center(
                      // Menggunakan gambar latar belakang dari assets/images/telegram_pattern.jpg
                      child: Image.asset(
                        'assets/images/telegram_pattern.jpg',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        repeat: ImageRepeat.repeat,
                        // errorBuilder jika gambar gagal dimuat dari aset
                        errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                          return const Center(child: Text('Failed to load background image from assets'));
                        },
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// Widget pembantu untuk item daftar chat yang lebih fleksibel
class ChatListItem extends StatelessWidget {
  final String? avatarText; // Opsional jika menggunakan ikon
  final IconData? avatarIcon; // Opsional jika menggunakan teks
  final Color? avatarColor; // Warna latar belakang avatar
  final String avatarType; // 'text' atau 'icon'

  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final VoidCallback? onTap;
  final bool isSelected; // Properti baru untuk status terpilih

  const ChatListItem({
    super.key,
    this.avatarText,
    this.avatarIcon,
    this.avatarColor,
    required this.avatarType,
    required this.name,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.onTap,
    this.isSelected = false, // Default tidak terpilih
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        // Latar belakang biru muda jika terpilih
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.withOpacity(0.05) : Colors.transparent,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: avatarColor ?? Colors.grey[300], // Gunakan warna yang diberikan atau default
              child: avatarType == 'icon' && avatarIcon != null
                  ? Icon(
                      avatarIcon,
                      color: Colors.white, // Ikon biasanya putih di latar belakang berwarna
                      size: 24,
                    )
                  : Text(
                      avatarText ?? '', // Teks avatar
                      style: TextStyle(
                        color: avatarColor != null ? Colors.white : Colors.black, // Teks avatar putih jika latar belakang berwarna
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Tambahkan ikon centang jika diperlukan (misalnya untuk Telegram)
                      if (name == 'Telegram' && isSelected) // Contoh: hanya untuk Telegram yang terpilih
                        Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Icon(Icons.check, size: 16, color: Colors.blue[700]),
                        ),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          lastMessage,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (unreadCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            unreadCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
