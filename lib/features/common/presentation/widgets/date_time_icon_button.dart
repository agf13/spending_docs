import 'package:flutter/material.dart';
import 'package:spending_docs/features/common/presentation/widgets/dateTimePicker.dart';

class DateTimeIconButton extends StatefulWidget {
  final void Function(String) onPressed;
  final bool onlyPickDate;

  const DateTimeIconButton({
    super.key,
    required this.onPressed,
    this.onlyPickDate = false,
  });

  @override
  State<DateTimeIconButton> createState() => _DateTimeIconButtonState();
}

class _DateTimeIconButtonState extends State<DateTimeIconButton> {
  @override
  Widget build(BuildContext context) {
    return dateTimeIconButton();
  }

  Widget dateTimeIconButton() {
    return IconButton(
      onPressed: handlePickedDateTime,
      icon: Icon(Icons.calendar_today),
    );
  }

  /*
    Returns the String representation of the picked time without the milliseconds.
    Ex.: "31-08-2026 21:45:31" instead of "31-08-2026 21:45:31.067916"
  */
  Future<void> handlePickedDateTime() async {
    DateTime? pickedDateTime = await pickDateTime(
      context,
      onlyPickDate: widget.onlyPickDate,
    );
    if (pickedDateTime != null) {
      // Removing the milliseconds from the date
      String dateTimeString = pickedDateTime.toString().split('.')[0];

      widget.onPressed(dateTimeString);
    }
  }
}
