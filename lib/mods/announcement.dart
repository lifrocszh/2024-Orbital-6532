// class Announcement extends StatelessWidget {
//   final String message;
//   final String user;
//   const Announcement({
//     super.key,
//     required this.message,
//     required this.user,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//       ),
//       margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
//       padding: const EdgeInsets.all(25),
//       child: Column(
//         children: [
//           Text(
//             user,
//             style: TextStyle(
//               color: Colors.grey[500],
//             ),
//           ),
//           const SizedBox(height: 10),
//           Text(message),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Announcement extends StatefulWidget {
  final String message;
  final String user;
  final String docId;
  final Map<String, dynamic> votes;
  final Function(String, bool) onVote;

  const Announcement({
    Key? key,
    required this.message,
    required this.user,
    required this.docId,
    required this.votes,
    required this.onVote,
  }) : super(key: key);

  @override
  _AnnouncementState createState() => _AnnouncementState();
}

class _AnnouncementState extends State<Announcement> {
  late int voteCount;
  late bool hasVoted;

  @override
  void initState() {
    super.initState();
    _updateVoteState();
  }

  void _updateVoteState() {
    final currentUser = FirebaseAuth.instance.currentUser;
    voteCount = widget.votes.values.where((v) => v == true).length;
    hasVoted = currentUser != null && widget.votes[currentUser.email] == true;
  }

  @override
  void didUpdateWidget(Announcement oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.votes != widget.votes) {
      _updateVoteState();
    }
  }

  void _handleVote() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && !hasVoted) {
      setState(() {
        voteCount++;
        hasVoted = true;
      });
      widget.onVote(widget.docId, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.user,
                style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(widget.message),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('People Coming: $voteCount'),
                ElevatedButton(
                  onPressed: hasVoted ? null : _handleVote,
                  child: Text(hasVoted ? 'Voted' : 'Coming'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
