import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:orbital/auth.dart';
import 'package:intl/intl.dart';
import 'package:orbital/pages/profile_page.dart';
import 'booking_page.dart';
import 'announcement_page.dart';
import 'package:orbital/mods/list_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  final currentUser = FirebaseAuth.instance.currentUser;

  // final String _name = 'Alex Tan';
  // final String _id = 'A1234567N';
  final DateTime _selectedDate = DateTime.now();
  final String _time = '10:00 AM'; // Placeholder for actual time
  final String _facility = 'Hard Court'; // Placeholder for actual facility

  List<String> userInfo = [];

  Future getUserInfo() async {
    await FirebaseFirestore.instance.collection('Users').get().then(
          (snapshot) => snapshot.docs.forEach((user) {
            print(user.reference);
            userInfo.add(user.reference.id);
          }),
        );
  }

  Future<void> signOut() async {
    await Auth().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'RafflesVUS',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
      ),
      drawer: Drawer(
        backgroundColor: const Color.fromRGBO(0, 64, 39, 1),
        child: Column(
          children: [
            // header
            const DrawerHeader(
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 64,
              ),
            ),
            // profile list tile
            MyListTile(
              icon: Icons.person,
              text: "P R O F I L E",
              onTap: () {
                Navigator.pop;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
                setState(() {});
              },
            ),

            // profile list tile
            MyListTile(icon: Icons.logout, text: 'L O G O U T', onTap: signOut)
          ],
        ),
      ),
      body: Column(
        children: [
          // logged in state

          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Logged in as: ",
                  style: TextStyle(fontSize: 16.0),
                ),
                Column(
                  children: [
                    Text(
                      "${currentUser!.email}",
                      style: const TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // test test

          // Expanded(
          //   child: FutureBuilder(
          //     future: getUserInfo(),
          //     builder: (context, index) {
          //       return ListView.builder(
          //         itemCount: userInfo.length,
          //         itemBuilder: (context, index) {
          //           return ListTile(
          //             title: GetUserID(docID: userInfo[index]),
          //           );
          //         },
          //       );
          //     },
          //   ),
          // ),

          Container(
            padding: const EdgeInsets.all(10.0),
            child: const Text(
              'Bookings',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          if (_selectedDate != null)
            // Display booking information if available
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Date:',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        DateFormat.yMMMd().format(_selectedDate),
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Time:',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _time,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Facility:',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        _facility,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ],
                ),
              ],
            ),

          // Buttons

          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Book facilities button
              Container(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const BookingPage()),
                    );
                    setState(() {});
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(Colors.greenAccent)),
                  child: const Text('Book Facilities'),
                ),
              ),

              // announcement button
              Container(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AnnouncementPage()),
                    );
                    setState(() {});
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(Colors.greenAccent)),
                  child: const Text('Announcements'),
                ),
              ),

              // sign out button
              // ElevatedButton(
              //   onPressed: signOut,
              //   style: ButtonStyle(
              //       minimumSize: WidgetStateProperty.all(
              //           const Size(80, 50)), // Adjust size values
              //       backgroundColor: WidgetStateProperty.all(Colors.grey[200])),
              //   child: const Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //     children: [
              //       Icon(Icons.logout),
              //       Text(
              //         'SIGN OUT',
              //         style: TextStyle(fontSize: 25, color: Colors.red),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
