import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:table_calendar/table_calendar.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _nameController = TextEditingController();
  // final String _nameError = '';
  DateTime _selectedDate = DateTime.now(); // Initialize with current date

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Facilities'),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            selectDateBar(),
            buildCalendar(),
            bookSlotButton(),
          ],
        ),
      ),
    );
  }

  Widget buildCalendar() {
    return TableCalendar(
      firstDay: DateTime(DateTime.now().year - 1),
      lastDay: DateTime(DateTime.now().year + 1),
      onDaySelected: (selectedDate, focusedDay) {
        setState(() {
          _selectedDate = selectedDate;
        });
      },
      focusedDay: _selectedDate,
      calendarFormat: CalendarFormat.month,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      daysOfWeekVisible: true,
      rowHeight: 50.0,
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleTextStyle: TextStyle(fontSize: 16.0),
      ),
      calendarStyle: const CalendarStyle(
        selectedTextStyle: TextStyle(color: Colors.white),
        selectedDecoration: BoxDecoration(
          color: Colors.yellow,
          shape: BoxShape.circle,
        ),
      ),
      // Remove selectedDayPredicate as it's not needed
    );
  }

  Widget selectDateBar() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: const Text(
        'Select Date',
        style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget bookSlotButton() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => {
              // Fluttertoast.showToast(msg: "yolo")
              _showBookingDialog(context)
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text('Book this slot'),
          ),
        ],
      ),
    );
  }

  void _showBookingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Enter Your Name'),
          content: TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'Enter Your Name',
              errorText: _nameController.text.isEmpty
                  ? 'Please enter your name'
                  : null,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_nameController.text.isNotEmpty) {
                  Navigator.pop(context); // Close this dialog
                  _showBookingConfirmation(
                      context); // Show booking confirmation
                } else {
                  setState(() {
                    // Update error message if needed (assuming using a stateful widget)
                  });
                }
              },
              child: const Text('SUBMIT'),
            ),
          ],
        );
      },
    );
  }

  void _showBookingConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Booking Done!'),
        content: const Text('Your booking has been confirmed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close both dialogs
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }
}
