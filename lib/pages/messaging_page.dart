import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orbital/mods/message_bubble.dart';

class MessagingPage extends StatefulWidget {
  final String currentUserEmail;
  final String otherUserEmail;

  const MessagingPage({
    Key? key,
    required this.currentUserEmail,
    required this.otherUserEmail,
  }) : super(key: key);

  @override
  _MessagingPageState createState() => _MessagingPageState();
}

class _MessagingPageState extends State<MessagingPage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String _chatRoomId;

  @override
  void initState() {
    super.initState();
    _chatRoomId =
        _getChatRoomId(widget.currentUserEmail, widget.otherUserEmail);
  }

  String _getChatRoomId(String user1, String user2) {
    return user1.compareTo(user2) < 0 ? '$user1-$user2' : '$user2-$user1';
  }

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _firestore
          .collection('chat_rooms')
          .doc(_chatRoomId)
          .collection('messages')
          .add({
        'sender': widget.currentUserEmail,
        'message': _messageController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.otherUserEmail}'),
        backgroundColor: Colors.greenAccent,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chat_rooms')
                  .doc(_chatRoomId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!.docs;
                List<Widget> messageWidgets = [];
                for (var message in messages) {
                  final messageText = message['message'];
                  final messageSender = message['sender'];

                  final messageWidget = MessageBubble(
                    sender: messageSender,
                    text: messageText,
                    isMe: widget.currentUserEmail == messageSender,
                  );

                  messageWidgets.add(messageWidget);
                }

                return ListView(
                  reverse: true,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  children: messageWidgets,
                );
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.greenAccent, width: 2),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                      ),
                      onSubmitted: (value) => _sendMessage(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                  color: Colors.greenAccent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
