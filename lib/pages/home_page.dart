import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:orbital/auth.dart';
import 'package:orbital/pages/profile_page.dart';
import 'booking_page.dart';
import 'announcement_page.dart';
import 'package:orbital/mods/list_tile.dart';
import 'package:intl/intl.dart';
import 'package:orbital/mods/booking.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> with WidgetsBindingObserver {
  final currentUser = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> userBookings = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getUserBookings();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getUserBookings();
    }
  }

  Future<void> getUserBookings() async {
    if (currentUser == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('Bookings')
        .where('userId', isEqualTo: currentUser!.email)
        .get();

    final bookings = snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'facility': doc['facility'],
        'date': doc['date'],
        'remarks': doc['remark'],
      };
    }).toList();

    final currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final filteredBookings = bookings.where((booking) {
      final bookingDate = booking['date'];
      return bookingDate.compareTo(currentDate) >= 0;
    }).toList();

    setState(() {
      userBookings = filteredBookings;
    });
  }

  Future<void> signOut() async {
    await Auth().signOut();
  }

  void handleDelete(String id) {
    setState(() {
      userBookings.removeWhere((booking) => booking['id'] == id);
    });
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
            const DrawerHeader(
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 64,
              ),
            ),
            MyListTile(
              icon: Icons.person,
              text: "P R O F I L E",
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfilePage(
                            userEmail: '${currentUser?.email}',
                          )),
                );
              },
            ),
            MyListTile(icon: Icons.logout, text: 'L O G O U T', onTap: signOut)
          ],
        ),
      ),
      body: Column(
        children: [
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
          Container(
            padding: const EdgeInsets.all(10.0),
            child: const Text(
              'Bookings',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: userBookings.isEmpty
                ? const Center(
                    child: Text(
                      "You have no bookings",
                      style: TextStyle(fontSize: 16.0),
                    ),
                  )
                : ListView.builder(
                    itemCount: userBookings.length,
                    itemBuilder: (context, index) {
                      final booking = userBookings[index];
                      return Booking(
                        id: booking['id'],
                        facility: booking['facility'],
                        date: booking['date'],
                        remarks: booking['remarks'],
                        onDelete: handleDelete,
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BookingPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Book Facilities',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AnnouncementPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Announcements',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
