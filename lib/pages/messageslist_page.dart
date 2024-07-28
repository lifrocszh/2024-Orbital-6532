import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'messaging_page.dart';

class MessagesListPage extends StatefulWidget {
  final String currentUserEmail;

  const MessagesListPage({
    Key? key,
    required this.currentUserEmail,
  }) : super(key: key);

  @override
  _MessagesListPageState createState() => _MessagesListPageState();
}

class _MessagesListPageState extends State<MessagesListPage> {
  Set<String> uniqueUsers = {};

  @override
  void initState() {
    super.initState();
    getMessengers();
  }

  Future<void> getMessengers() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('chat_rooms').get();
      final chatRooms = snapshot.docs;

      for (var chatRoom in chatRooms) {
        final chatRoomId = chatRoom.id;
        final users = chatRoomId.split('-');
        final otherUserEmail = users.firstWhere(
          (email) => email != widget.currentUserEmail,
          orElse: () => '',
        );

        if (otherUserEmail.isNotEmpty) {
          setState(() {
            uniqueUsers.add(otherUserEmail);
          });
        }
      }
    } catch (e) {
      print('Error fetching messengers: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
        backgroundColor: Colors.greenAccent,
      ),
      body: uniqueUsers.isEmpty
          ? Center(
              child: Text('No messages yet.'),
            )
          : ListView(
              children: uniqueUsers.map((userEmail) {
                return ListTile(
                  title: Text(userEmail),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MessagingPage(
                          currentUserEmail: widget.currentUserEmail,
                          otherUserEmail: userEmail,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
    );
  }
}
