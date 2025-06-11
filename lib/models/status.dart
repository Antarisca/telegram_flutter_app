    // --- File: lib/models/status.dart ---
    // Lokasi: TELEGRAM1/lib/models/status.dart

    import 'package:flutter/material.dart'; // Hanya untuk Key, tidak esensial untuk model

    class Status {
      final int id;
      final int userId;
      final String? username; // Opsional, dari join di PHP
      final String content;
      final String? imageUrl; // Nullable karena opsional
      final String timestamp; // Waktu status diunggah

      Status({
        required this.id,
        required this.userId,
        this.username,
        required this.content,
        this.imageUrl,
        required this.timestamp,
      });

      // Factory constructor untuk membuat objek Status dari JSON
      factory Status.fromJson(Map<String, dynamic> json) {
        return Status(
          id: int.parse(json['id'].toString()), // Pastikan parsing ke int
          userId: int.parse(json['user_id'].toString()),
          username: json['username'] as String?, // Mungkin null jika join gagal
          content: json['content'] as String,
          imageUrl: json['image_url'] as String?, // Bisa null
          timestamp: json['timestamp'] as String,
        );
      }
    }
    