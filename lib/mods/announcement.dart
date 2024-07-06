import 'package:flutter/material.dart';

class Announcement extends StatelessWidget {
  final String message;
  final String user;
  const Announcement({
    super.key,
    required this.message,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: EdgeInsets.all(25),
      child: Column(
        children: [
          Text(
            user,
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 10),
          Text(message),
        ],
      ),
    );
  }
}
