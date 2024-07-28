// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:orbital/mods/announcement.dart';

// class AnnouncementPage extends StatefulWidget {
//   const AnnouncementPage({super.key});

//   @override
//   State<AnnouncementPage> createState() => _AnnouncementPageState();
// }

// class _AnnouncementPageState extends State<AnnouncementPage> {
//   final currentUser = FirebaseAuth.instance.currentUser;
//   final TextEditingController _textEditingController = TextEditingController();

//   Widget loggedInState() {
//     return Container(
//       color: Colors.grey[200],
//       padding: const EdgeInsets.all(10.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const Text(
//             "Logged in as: ",
//             style: TextStyle(fontSize: 16.0),
//           ),
//           Text(
//             "${currentUser!.email}",
//             style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<String> getUserName() async {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       DocumentSnapshot userDoc = await FirebaseFirestore.instance
//           .collection('Users')
//           .doc(currentUser!.email)
//           .get();
//       return userDoc['Name'] ?? user.email ?? 'Anonymous';
//     }
//     return 'Anonymous';
//   }

//   Widget announcementWidget() {
//     final ScrollController _scrollController = ScrollController();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (_scrollController.hasClients) {
//         _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
//       }
//     });

//     return Expanded(
//       child: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection("User Announcements")
//             .orderBy(
//               "Timestamp",
//               descending: false,
//             )
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return ListView.builder(
//               itemCount: snapshot.data!.docs.length,
//               itemBuilder: (context, index) {
//                 final post = snapshot.data!.docs[index];
//                 return Announcement(
//                   message: post['Message'],
//                   user: post['Name'],
//                   docId: post.id,
//                   votes: Map<String, dynamic>.from(post['Votes'] ?? {}),
//                   onVote: _handleVote,
//                   userEmail: post['Email'], // Add this line
//                 );
//               },
//             );
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text('Error: ${snapshot.error}'),
//             );
//           }
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         },
//       ),
//     );
//   }

//   void _handleVote(String docId, bool vote) {
//     final user = FirebaseAuth.instance.currentUser;
//     if (user != null) {
//       FirebaseFirestore.instance
//           .collection("User Announcements")
//           .doc(docId)
//           .set({
//         'Votes': {user.email: vote}
//       }, SetOptions(merge: true));
//     }
//   }

//   Widget announcementTextBox() {
//     return Padding(
//       padding: const EdgeInsets.all(17.0),
//       child: Row(
//         children: <Widget>[
//           Expanded(
//             child: TextField(
//               controller: _textEditingController,
//               onSubmitted: postAnnouncementOnSubmit,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 hintText: 'Write an announcement',
//               ),
//             ),
//           ),
//           IconButton(
//             onPressed: postAnnouncement,
//             icon: const Icon(
//               Icons.arrow_circle_up_outlined,
//               size: 40.0,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> postAnnouncement() async {
//     if (_textEditingController.text.isNotEmpty) {
//       String userName = await getUserName();
//       FirebaseFirestore.instance.collection("User Announcements").add({
//         'Email': currentUser?.email,
//         'Name': userName,
//         'Message': _textEditingController.text,
//         'Timestamp': Timestamp.now(),
//         'Votes': {},
//       });
//       _textEditingController.clear();
//     }
//   }

//   Future<void> postAnnouncementOnSubmit(String string) async {
//     if (string != '') {
//       String userName = await getUserName();
//       FirebaseFirestore.instance.collection("User Announcements").add({
//         'Email': currentUser?.email,
//         'Name': userName,
//         'Message': string,
//         'Timestamp': Timestamp.now(),
//         'Votes': {},
//       });
//       _textEditingController.clear();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.green[100],
//         appBar: AppBar(
//           title: const Text(
//             'Announcements',
//             style: TextStyle(fontWeight: FontWeight.w600),
//           ),
//           centerTitle: true,
//           backgroundColor: Colors.greenAccent,
//         ),
//         body: Column(
//           children: [
//             // logged in state
//             loggedInState(),
//             announcementWidget(),
//             announcementTextBox(),
//           ],
//         ));
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:orbital/mods/announcement.dart';

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({super.key});

  @override
  State<AnnouncementPage> createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  final TextEditingController _textEditingController = TextEditingController();

  Widget loggedInState() {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Logged in as: ",
            style: TextStyle(fontSize: 16.0),
          ),
          Text(
            "${currentUser!.email}",
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Future<String> getUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.email)
          .get();
      return userDoc['Name'] ?? user.email ?? 'Anonymous';
    }
    return 'Anonymous';
  }

  Widget announcementWidget() {
    final ScrollController _scrollController = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });

    return Expanded(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("User Announcements")
            .orderBy(
              "Timestamp",
              descending: false,
            )
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final post = snapshot.data!.docs[index];
                return Announcement(
                  message: post['Message'],
                  user: post['Name'],
                  docId: post.id,
                  votes: Map<String, dynamic>.from(post['Votes'] ?? {}),
                  onVote: _handleVote,
                  userEmail: post['Email'],
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  void _handleVote(String docId, bool vote) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection("User Announcements")
          .doc(docId)
          .set({
        'Votes': {user.email!: vote}
      }, SetOptions(merge: true));
    }
  }

  Widget announcementTextBox() {
    return Padding(
      padding: const EdgeInsets.all(17.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textEditingController,
              onSubmitted: postAnnouncementOnSubmit,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Write an announcement',
              ),
            ),
          ),
          IconButton(
            onPressed: postAnnouncement,
            icon: const Icon(
              Icons.arrow_circle_up_outlined,
              size: 40.0,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> postAnnouncement() async {
    if (_textEditingController.text.isNotEmpty) {
      String userName = await getUserName();
      FirebaseFirestore.instance.collection("User Announcements").add({
        'Email': currentUser?.email,
        'Name': userName,
        'Message': _textEditingController.text,
        'Timestamp': Timestamp.now(),
        'Votes': {},
      });
      _textEditingController.clear();
    }
  }

  Future<void> postAnnouncementOnSubmit(String string) async {
    if (string != '') {
      String userName = await getUserName();
      FirebaseFirestore.instance.collection("User Announcements").add({
        'Email': currentUser?.email,
        'Name': userName,
        'Message': string,
        'Timestamp': Timestamp.now(),
        'Votes': {},
      });
      _textEditingController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        title: const Text(
          'Announcements',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
      ),
      body: Column(
        children: [
          loggedInState(),
          announcementWidget(),
          announcementTextBox(),
        ],
      ),
    );
  }
}
