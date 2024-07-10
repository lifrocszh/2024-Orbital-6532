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
  static List<String> list = [
    'Hall',
    'Basketball Court',
    'Lounge',
    'Study Room'
  ];
  List<DropdownMenuItem<String>> dropdownlist =
      list.map<DropdownMenuItem<String>>((String facilityName) {
    return DropdownMenuItem<String>(
      value: facilityName,
      child: Text(facilityName),
    );
  }).toList();
  String? _selectedFacility;

  // @override
  // void initState() {
  //   super.initState();
  //   fetchHairdressers();
  // }

  // fetchHairdressers() async {
  //   // Fetch facilityies from Firestore and update local list
  //   var querySnapshot = await FirebaseFirestore.instance
  //       .collection('Users')
  //       .where('userType', isEqualTo: 2)
  //       .get();
  //   setState(() {
  //     list = querySnapshot.docs
  //         .map((doc) => doc.get('userName') as String)
  //         .toList();
  //   });
  // }

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
        'facility': _selectedFacility,
        'date': _selectedDay,
        'time': selectedTime.format(context),
      });

      // Show a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Facility Booked!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: const Text(
          'Book Facilities',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
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
              title: const Text('Select Time'),
              trailing: Text(selectedTime.format(context)),
              onTap: () => _selectTime(context),
            ),

            // select facility
            Container(
              padding: const EdgeInsets.all(15),
              child: DropdownButton<String>(
                value:
                    _selectedFacility, // Initially set to null for empty selection
                isExpanded: true,
                hint: const Text('Select Facility'),
                icon: const Icon(Icons.arrow_downward),
                elevation: 10,
                onChanged: (String? value) {
                  setState(() {
                    _selectedFacility = value!;
                  });
                },
                items: dropdownlist,
                //     list.map<DropdownMenuItem<String>>((String facilityName) {
                //   return DropdownMenuItem<String>(
                //     value: facilityName,
                //     child: Text(facilityName),
                //   );
                // }).toList(),
              ),
            ),
            ElevatedButton(
              onPressed: bookAppointment,
              child: const Text('Book Facility'),
            ),
          ],
        ),
      ),
    );
  }
}
