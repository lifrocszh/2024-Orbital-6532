import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Booking extends StatelessWidget {
  final String id;
  final String facility;
  final String date;
  final String remarks;
  final Function(String) onDelete;

  const Booking({
    required this.id,
    required this.facility,
    required this.date,
    required this.remarks,
    required this.onDelete,
    Key? key,
  }) : super(key: key);

  Future<void> deleteBooking(BuildContext context) async {
    await FirebaseFirestore.instance.collection('Bookings').doc(id).delete();
    onDelete(id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Booking for $facility on $date deleted.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async {
        await deleteBooking(context);
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Facility: $facility',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await deleteBooking(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text('Date: $date', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 5),
              Text('Remarks: $remarks', style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
