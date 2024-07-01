import "package:intl/intl.dart";

class Booking {
  final DateFormat date;
  final String name;
  final String facility;

  const Booking(this.date, this.name, this.facility);

  DateFormat get_date() {
    return this.date;
  }

  String get_name() {
    return this.name;
  }

  String get_facility() {
    return this.facility;
  }
}
