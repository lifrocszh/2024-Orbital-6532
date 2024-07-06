import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:orbital/auth.dart';
import 'package:intl/intl.dart';
// import 'package:orbital/pages/login_page.dart';
import 'package:orbital/pages/booking_page.dart';
import 'package:orbital/pages/announcement_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  final currentUser = FirebaseAuth.instance.currentUser;

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
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }

  // final String _name = 'Alex Tan';
  // final String _id = 'A1234567N';
  final DateTime _selectedDate = DateTime.now();
  final String _time = '10:00 AM'; // Placeholder for actual time
  final String _facility = 'Hard Court'; // Placeholder for actual facility

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget signOutButton() {
    return ElevatedButton(
      onPressed: signOut,
      style: ButtonStyle(
          minimumSize: WidgetStateProperty.all(const Size(200.0, 80.0)),
          backgroundColor: WidgetStateProperty.all(Colors.grey[200])),
      child: const Text(
        'SIGN OUT',
        style: TextStyle(fontSize: 25, color: Colors.red),
      ),
    );
  }

  Widget bookFacilitiesButton() {
    return ElevatedButton(
      onPressed: () {
        // Handle "Book Facilities" button press
        // Update booking information in state
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BookingPage()),
        );
        setState(() {});
      },
      style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.greenAccent)),
      child: const Text('Book Facilities'),
    );
  }

  Widget announcementsButton() {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AnnouncementPage()),
        );
        setState(() {});
      },
      style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(Colors.greenAccent)),
      child: const Text('Announcements'),
    );
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
      body: Column(
        children: [
          loggedInState(),
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
          Container(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [bookFacilitiesButton()],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                child: announcementsButton(),
              ),
              Container(
                padding: const EdgeInsets.all(30.0),
                child: signOutButton(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
