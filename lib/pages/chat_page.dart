// --- File: lib/pages/chat_page.dart ---
// Lokasi: TELEGRAM1/lib/pages/chat_page.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:TELEGRAM1/models/message.dart'; // Import the Message model

// Global data structure to store messages for each chat.
// The key is the recipientUsername, the value is the list of messages for that chat.
// This ensures that each chat has its own separate message history.
Map<String, List<Message>> _allChatMessages = {
  'FILIM DISNEY SUB INDO': [
    Message(
      id: 7, // Unique ID
      senderId: 999, // Example ID for FILIM DISNEY SUB INDO
      senderUsername: 'FILIM DISNEY SUB INDO',
      receiverId: 1, // Current logged-in user ID (e.g., hesti)
      receiverUsername: 'hesti',
      content: 'Moana 2 (2024)', // Main title
      timestamp: '2025-04-09 14:02:00', // Date Apr 9
      type: 'movie_post', // Message type is a movie post
      extraData: {
        'imageUrl': 'https://placehold.co/300x450/000000/FFFFFF?text=MOANA+2+POSTER', // Moana 2 poster placeholder image
        'description': 'bercerita tentang petualangan Moana dan Maui dalam mencari Pulau Motufetu yang hilang, mematahkan kutukan dewa Nalo, dan menghubungkan kembali penduduk lautan.',
        'likes': 12,
        'hearts': 3,
        'comments': 8500, // 8.5K
      },
    ),
  ],
  'Telegram': [
    Message(
      id: 1,
      senderId: 1000, // Example ID for Telegram
      senderUsername: 'Telegram',
      receiverId: 1, // Current logged-in user ID (e.g., hesti)
      receiverUsername: 'hesti',
      content: 'Kode masuk Anda: 68257 Jangan pernah memberikan kode ini ke siapapun, walaupun mereka mengatakan mereka dari Telegram!',
      timestamp: '2025-05-26 22:33:00',
      type: 'text', // Message type is plain text
    ),
    Message(
      id: 2,
      senderId: 1000, // Example ID for Telegram
      senderUsername: 'Telegram',
      receiverId: 1, // Current logged-in user ID (e.g., hesti)
      receiverUsername: 'hesti',
      content: '! Kode ini dapat digunakan untuk masuk ke akun Telegram Anda. Kami tidak pernah memintanya untuk hal lain.',
      timestamp: '2025-05-26 22:33:00',
      type: 'text',
    ),
    Message(
      id: 3,
      senderId: 1000, // Example ID for Telegram
      senderUsername: 'Telegram',
      receiverId: 1, // Current logged-in user ID (e.g., hesti)
      receiverUsername: 'hesti',
      content: 'Jika Anda tidak meminta kode ini dengan mencoba masuk di perangkat lain, abaikan pesan ini.',
      timestamp: '2025-05-26 22:33:00',
      type: 'text',
    ),
    Message(
      id: 4,
      senderId: 1000, // Example ID for Telegram
      senderUsername: 'Telegram',
      receiverId: 1, // Current logged-in user ID (e.g., hesti)
      receiverUsername: 'hesti',
      content: 'Kode masuk Anda: 39108 Jangan pernah memberikan kode ini ke siapapun, walaupun mereka mengatakan mereka dari Telegram!',
      timestamp: '2025-05-27 00:30:00',
      type: 'text',
    ),
    Message(
      id: 5,
      senderId: 1000, // Example ID for Telegram
      senderUsername: 'Telegram',
      receiverId: 1, // Current logged-in user ID (e.g., hesti)
      receiverUsername: 'hesti',
      content: '! Kode ini dapat digunakan untuk masuk ke akun Telegram Anda. Kami tidak pernah memintanya untuk hal lain.',
      timestamp: '2025-05-27 00:30:00',
      type: 'text',
    ),
    Message(
      id: 6,
      senderId: 1000, // Example ID for Telegram
      senderUsername: 'Telegram',
      receiverId: 1, // Current logged-in user ID (e.g., hesti)
      receiverUsername: 'hesti',
      content: 'Jika Anda tidak meminta kode ini dengan mencoba masuk di perangkat lain, abaikan pesan ini.',
      timestamp: '2025-05-27 00:30:00',
      type: 'text',
    ),
  ],
  // You can add other hardcoded chats here
};


class ChatPage extends StatefulWidget {
  final int currentUserId; // ID of the currently logged-in user
  final int recipientId; // ID of the user being chatted with
  final String recipientUsername; // Username of the user being chatted with

  const ChatPage({
    Key? key,
    required this.currentUserId,
    required this.recipientId,
    required this.recipientUsername,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  // _messages will now be a direct reference to the list in _allChatMessages
  late List<Message> _messages;
  bool _isLoading = true;
  final ScrollController _scrollController = ScrollController(); // To control scrolling

  // --- IMPORTANT: ADJUST THIS URL FOR LOCAL TESTING ---
  // If you are testing on an Android emulator, try using 'http://10.0.2.2/telegram_app/api_chat.php'
  // If you are testing on a physical device, use your computer's local IP address (e.g., 'http://192.168.1.40/telegram_app/api_chat.php')
  final String _apiChatUrl = 'http://192.168.1.40/telegram_app/api_chat.php'; // Replace with your actual IP or 10.0.2.2 for emulator

  @override
  void initState() {
    super.initState();

    // Ensure there is an entry for this recipientUsername in _allChatMessages.
    // If not, initialize with an empty list.
    if (!_allChatMessages.containsKey(widget.recipientUsername)) {
      _allChatMessages[widget.recipientUsername] = [];
    }

    // Set _messages as a direct reference to the message list for this chat.
    // This ensures that any changes to _messages will affect the list in _allChatMessages.
    _messages = _allChatMessages[widget.recipientUsername]!;

    _isLoading = false; // Set loading to false as hardcoded data is available

    // Add a listener to the message controller so the icon changes dynamically
    _messageController.addListener(_onMessageChanged);

    // Automatically scroll to the bottom after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
    // _fetchMessages(); // Enable this if you want to load messages from the API
  }

  @override
  void dispose() {
    _messageController.removeListener(_onMessageChanged); // Remove listener on dispose
    _messageController.dispose();
    _scrollController.dispose(); // Dispose scroll controller
    super.dispose();
  }

  // Function to handle text changes in the message input field
  void _onMessageChanged() {
    setState(() {
      // This will trigger a rebuild and change the send button icon
      // based on whether _messageController.text is empty or not.
    });
  }

  // Function to fetch chat messages from the API (kept for future functionality)
  Future<void> _fetchMessages() async {
    if (!mounted) return; // Ensure the widget is still mounted
    setState(() {
      _isLoading = true;
    });
    try {
      final response = await http.get(
        Uri.parse('$_apiChatUrl?sender_id=${widget.currentUserId}&receiver_id=${widget.recipientId}'),
      );

      if (response.statusCode == 200) {
        final dynamic responseBody = jsonDecode(response.body);
        if (responseBody is Map && responseBody.containsKey('message')) {
            // If the API returns an empty message or no data
            setState(() {
                _messages.clear(); // Clear existing messages if no data from API
            });
        } else if (responseBody is List) {
            setState(() {
                // Caution: if _messages is already a reference to _allChatMessages,
                // then clearing and re-adding will affect _allChatMessages.
                // For hardcoded data, _fetchMessages is not used.
                _messages.clear();
                _messages.addAll(responseBody.map((json) => Message.fromJson(json)).toList());
            });
        }
      } else {
        _showSnackBar('Failed to load messages: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackBar('Network error occurred: $e');
      print('Error fetching messages: $e');
    } finally {
      if (mounted) { // Ensure the widget is still mounted before setState
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Function to send a new message
  Future<void> _sendMessage() async {
    if (_messageController.text.isEmpty) {
      _showSnackBar('Message cannot be empty!');
      return;
    }

    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch, // Unique ID based on timestamp
      senderId: widget.currentUserId,
      senderUsername: 'hesti', // Assumed sender username
      receiverId: widget.recipientId,
      receiverUsername: widget.recipientUsername,
      content: _messageController.text,
      timestamp: DateTime.now().toIso8601String().substring(0, 19).replaceFirst('T', ' '), // Format: YYYY-MM-DD HH:MM:SS
      type: 'text', // Default type for user-sent messages
    );

    // Add the new message to the local list and update the global map
    setState(() {
      _messages.add(newMessage);
      _allChatMessages[widget.recipientUsername] = _messages; // Update the global map
      _messageController.clear(); // Clear the input field
    });

    _scrollToBottom(); // Scroll to the bottom after sending a message

    // --- API call to send message (uncomment if you have a working backend) ---
    /*
    try {
      final response = await http.post(
        Uri.parse(_apiChatUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'sender_id': newMessage.senderId,
          'receiver_id': newMessage.receiverId,
          'content': newMessage.content,
          'timestamp': newMessage.timestamp,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody['status'] == 'success') {
          // Message sent successfully, no need to do anything as it's already added locally
        } else {
          _showSnackBar('Failed to send message: ${responseBody['message']}');
          // Optionally, remove the message from the local list if sending failed
          setState(() {
            _messages.remove(newMessage);
          });
        }
      } else {
        _showSnackBar('Failed to send message: Server error ${response.statusCode}');
        setState(() {
          _messages.remove(newMessage);
        });
      }
    } catch (e) {
      _showSnackBar('Network error occurred: $e');
      print('Error sending message: $e');
      setState(() {
        _messages.remove(newMessage);
      });
    }
    */
  }

  // Function to scroll to the bottom of the chat list
  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  // Function to show a SnackBar message
  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  // Helper function to format timestamp for display
  String _formatTimestamp(String timestamp) {
    final DateTime dateTime = DateTime.parse(timestamp);
    final String hour = dateTime.hour.toString().padLeft(2, '0');
    final String minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Profile picture placeholder
            CircleAvatar(
              backgroundColor: Colors.blueGrey,
              child: Text(
                widget.recipientUsername.isNotEmpty
                    ? widget.recipientUsername[0].toUpperCase()
                    : '',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            Text(widget.recipientUsername),
          ],
        ),
        backgroundColor: const Color(0xFF527DA3), // Telegram blue
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {
              // Handle call action
            },
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {
              // Handle video call action
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Handle more options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller: _scrollController, // Attach the scroll controller
                    padding: const EdgeInsets.all(8.0),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      // Determine if the message is sent by the current user
                      final bool isMe = message.senderId == widget.currentUserId;

                      if (message.type == 'movie_post') {
                        return _buildMoviePostMessage(message);
                      } else {
                        return _buildTextMessage(message, isMe);
                      }
                    },
                  ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  // Widget to build a standard text message bubble
  Widget _buildTextMessage(Message message, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFFE3FFDA) : Colors.white, // Lighter green for sent, white for received
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft: isMe ? const Radius.circular(15) : const Radius.circular(0),
            bottomRight: isMe ? const Radius.circular(0) : const Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: const TextStyle(color: Colors.black87, fontSize: 16.0),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTimestamp(message.timestamp),
              style: TextStyle(
                color: Colors.black54,
                fontSize: 10.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to build a movie post message
  Widget _buildMoviePostMessage(Message message) {
    final extraData = message.extraData ?? {};
    final imageUrl = extraData['imageUrl'] as String? ?? 'https://placehold.co/300x450/cccccc/000000?text=No+Image';
    final description = extraData['description'] as String? ?? 'No description available.';
    final likes = extraData['likes'] as int? ?? 0;
    final hearts = extraData['hearts'] as int? ?? 0;
    final comments = extraData['comments'] as int? ?? 0;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Movie Title
            Text(
              message.content, // This is the movie title
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            // Movie Poster
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            // Description
            Text(
              description,
              style: const TextStyle(fontSize: 14.0, color: Colors.black87),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            // Engagement Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.thumb_up, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text('$likes', style: TextStyle(color: Colors.grey[600])),
                    const SizedBox(width: 12),
                    Icon(Icons.favorite, size: 16, color: Colors.red[400]),
                    const SizedBox(width: 4),
                    Text('$hearts', style: TextStyle(color: Colors.grey[600])),
                  ],
                ),
                Text('$comments comments', style: TextStyle(color: Colors.grey[600])),
              ],
            ),
            const SizedBox(height: 8),
            // View Post Button (example)
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Handle view post action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF527DA3), // Telegram blue
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Lihat Postingan'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to build the message input area
  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      color: Colors.white,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file, color: Colors.grey),
            onPressed: () {
              // Handle attachment
            },
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              ),
              onSubmitted: (_) => _sendMessage(), // Send message on pressing Enter
            ),
          ),
          const SizedBox(width: 8.0),
          CircleAvatar(
            backgroundColor: const Color(0xFF527DA3), // Telegram blue
            child: IconButton(
              icon: Icon(
                _messageController.text.isEmpty ? Icons.mic : Icons.send, // Dynamic icon
                color: Colors.white,
              ),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}
