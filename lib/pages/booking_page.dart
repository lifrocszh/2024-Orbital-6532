import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:orbital/pages/home_page.dart';

class BookingPage extends StatefulWidget {
  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  static List<String> facilities = [
    'Hall',
    'Basketball Court',
    'Lounge',
    'Study Room'
  ];
  String? _selectedFacility;
  Map<DateTime, Map<String, dynamic>> _bookedDates = {};
  final TextEditingController _remarkController = TextEditingController();
  Map<String, dynamic>? _currentBooking;

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  Future<void> _fetchBookings() async {
    if (_selectedFacility == null) return;

    final bookings = await FirebaseFirestore.instance
        .collection('Bookings')
        .where('facility', isEqualTo: _selectedFacility)
        .get();

    setState(() {
      _bookedDates = {};
      for (var doc in bookings.docs) {
        final data = doc.data();
        final dateTime = DateTime.parse(data['date'] as String);
        _bookedDates[DateTime(dateTime.year, dateTime.month, dateTime.day)] =
            data;
      }
    });
    _updateCurrentBooking();
  }

  void _updateCurrentBooking() {
    final key =
        DateTime(_selectedDay.year, _selectedDay.month, _selectedDay.day);
    setState(() {
      _currentBooking = _bookedDates[key];
    });
  }

  Future<void> bookAppointment() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null && _selectedFacility != null) {
      final dateString = _selectedDay.toIso8601String().split('T')[0];

      final userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.email)
          .get();
      final userName = userDoc.data()?['Name'] ?? 'Anonymous';
      final userBlock = userDoc.data()?['Block'] ?? 'Unknown';

      final existingBooking = await FirebaseFirestore.instance
          .collection('Bookings')
          .where('date', isEqualTo: dateString)
          .where('facility', isEqualTo: _selectedFacility)
          .get();

      if (existingBooking.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'This facility is already booked for the selected date.')),
        );
        return;
      }

      await FirebaseFirestore.instance.collection('Bookings').add({
        'userId': user.email,
        'userName': userName,
        'userBlock': userBlock,
        'facility': _selectedFacility,
        'date': dateString,
        'remark': _remarkController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Facility Booked!')),
      );

      await _fetchBookings();
      _remarkController.clear();
      _updateCurrentBooking();
    }
  }

  bool isDateBooked(DateTime date) {
    final key = DateTime(date.year, date.month, date.day);
    return _bookedDates.containsKey(key);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
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
                    _focusedDay = focusedDay;
                  });
                  _updateCurrentBooking();
                },
              ),
              Container(
                padding: const EdgeInsets.all(15),
                child: DropdownButton<String>(
                  value: _selectedFacility,
                  isExpanded: true,
                  hint: const Text('Select Facility'),
                  icon: const Icon(Icons.arrow_downward),
                  elevation: 10,
                  onChanged: (String? value) {
                    setState(() {
                      _selectedFacility = value!;
                      _fetchBookings();
                    });
                  },
                  items: facilities
                      .map<DropdownMenuItem<String>>((String facilityName) {
                    return DropdownMenuItem<String>(
                      value: facilityName,
                      child: Text(facilityName),
                    );
                  }).toList(),
                ),
              ),
              if (_currentBooking == null) ...[
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextField(
                    controller: _remarkController,
                    decoration: const InputDecoration(
                      hintText: 'Remark',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: bookAppointment,
                  child: const Text('Book Facility'),
                ),
              ] else ...[
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      const Text(
                        'Someone has already booked this facility for the day.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Here are the details of the booking',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Facility: ${_currentBooking!['facility']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text('Date: ${_currentBooking!['date']}',
                                    style: const TextStyle(fontSize: 16)),
                                const SizedBox(height: 5),
                                Text(
                                    'Booked by: ${_currentBooking!['userName']}',
                                    style: const TextStyle(fontSize: 16)),
                                const SizedBox(height: 5),
                                Text('Email: ${_currentBooking!['userId']}',
                                    style: const TextStyle(fontSize: 16)),
                                const SizedBox(height: 5),
                                Text('Block: ${_currentBooking!['userBlock']}',
                                    style: const TextStyle(fontSize: 16)),
                                const SizedBox(height: 5),
                                Text('Remark: ${_currentBooking!['remark']}',
                                    style: const TextStyle(fontSize: 16)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
