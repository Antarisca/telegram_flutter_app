// --- File: lib/models/message.dart ---
// Lokasi: TELEGRAM1/lib/models/message.dart

class Message {
  final int id;
  final int senderId;
  final String senderUsername;
  final int receiverId;
  final String receiverUsername;
  final String content;
  final String timestamp;
  final String type; // Tipe pesan: 'text' atau 'movie_post'
  final Map<String, dynamic>? extraData; // Data tambahan untuk tipe pesan tertentu (misal: movie_post)

  Message({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.senderUsername,
    required this.receiverUsername,
    required this.content,
    required this.timestamp,
    this.type = 'text', // Default ke 'text'
    this.extraData,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      senderId: json['sender_id'],
      receiverId: json['receiver_id'],
      senderUsername: json['sender_username'],
      receiverUsername: json['receiver_username'],
      content: json['message_content'],
      timestamp: json['timestamp'],
      type: json['type'] ?? 'text', // Jika 'type' tidak ada, default ke 'text'
      extraData: json['extra_data'] != null ? Map<String, dynamic>.from(json['extra_data']) : null,
    );
  }
}
