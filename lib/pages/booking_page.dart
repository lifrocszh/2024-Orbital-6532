import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String selectedHairdresser = '';
  List<String> hairdressers =
      []; // This will be populated with hairdressers from Firestore

  @override
  void initState() {
    super.initState();
    fetchHairdressers();
  }

  fetchHairdressers() async {
    // Fetch hairdresser (type 2 users) from Firestore and update local list
    var querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('userType', isEqualTo: 2)
        .get();
    setState(() {
      hairdressers = querySnapshot.docs
          .map((doc) => doc.get('userName') as String)
          .toList();
    });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  bookAppointment() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;

      await FirebaseFirestore.instance.collection('Booking').add({
        'userId': uid,
        'hairdresser': selectedHairdresser,
        'date': _selectedDay,
        'time': selectedTime.format(context),
      });

      // Show a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Appointment Booked!'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book an Appointment'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2040, 3, 14),
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay =
                      focusedDay; // update `_focusedDay` here to change the calendar's focus without rebuilding it completely
                });
              },
            ),
            ListTile(
              title: Text('Select Time'),
              trailing: Text(selectedTime.format(context)),
              onTap: () => _selectTime(context),
            ),
            DropdownButton<String>(
              value: selectedHairdresser.isEmpty ? null : selectedHairdresser,
              hint: Text('Select a Hairdresser'),
              onChanged: (newValue) {
                setState(() {
                  selectedHairdresser = newValue ?? '';
                });
              },
              items: hairdressers.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: bookAppointment,
              child: Text('Book Appointment'),
            ),
          ],
        ),
      ),
    );
  }
}
