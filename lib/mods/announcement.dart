import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:orbital/pages/profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement extends StatefulWidget {
  final String message;
  final String user;
  final String docId;
  final Map<String, dynamic> votes;
  final Function(String, bool) onVote;
  final String userEmail;

  const Announcement({
    Key? key,
    required this.message,
    required this.user,
    required this.docId,
    required this.votes,
    required this.onVote,
    required this.userEmail,
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

  Future<String?> _getProfileImageUrl(String email) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('Users').doc(email).get();
    return userDoc['profilePicture'];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getProfileImageUrl(widget.userEmail),
        builder: (context, snapshot) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          final currentUser = FirebaseAuth.instance.currentUser;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilePage(
                                userEmail: widget.userEmail,
                                currentUserEmail: currentUser?.email ?? '',
                              ),
                            ),
                          );
                        },
                        child: snapshot.connectionState ==
                                ConnectionState.waiting
                            ? CircularProgressIndicator()
                            : CircleAvatar(
                                radius: 20,
                                backgroundImage:
                                    snapshot.hasData && snapshot.data != null
                                        ? NetworkImage(snapshot.data!)
                                        : null,
                                child: snapshot.hasData && snapshot.data != null
                                    ? null
                                    : const Icon(Icons.person, size: 24),
                              ),
                      ),
                      const SizedBox(width: 8),
                      Text(widget.user,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
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
        });
  }
}
