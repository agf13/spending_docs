import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_docs/features/common/blocs/timePickerCubit.dart';

Future<DateTime?> pickDateTime(BuildContext context) async {
  try {
    // Pick date
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.fromMillisecondsSinceEpoch(0),
      lastDate: DateTime(2100),
    );

    // If user closed the picker return null
    if (pickedDate == null) return null;

    // If the widget calling this is no longer mounted, return
    if (!context.mounted) return null;

    // Wait for picking time
    await showModalBottomSheet(
      context: context,
      builder: (builderContext) => TimePicker(),
    );

    // After picking the time, store the picked value
    Duration? chosenDuration;
    if (context.mounted) {
      chosenDuration = context.read<TimePickerCubit>().state;
    } else {
      return null;
    }

    // Ensure a value to chosenDuration;
    chosenDuration ??= Duration.zero;

    // Merge date and time values
    return mergeDateTime(pickedDate, chosenDuration);
  } catch (e) {
    return null;
  }
}

DateTime mergeDateTime(DateTime pickedDate, Duration chosenDuration) {
  return DateTime(
    pickedDate.year,
    pickedDate.month,
    pickedDate.day,
  ).add(chosenDuration);
}

class TimePicker extends StatefulWidget {
  const TimePicker({super.key});

  @override
  State<TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<TimePicker> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // Time picker
          Expanded(
            child: CupertinoTimerPicker(
              mode: CupertinoTimerPickerMode.hms,
              initialTimerDuration: Duration.zero,
              onTimerDurationChanged: (newTimeDuration) {
                context.read<TimePickerCubit>().setDuration(newTimeDuration);
              },
            ),
          ),

          // Save button
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Confirm time'),
          ),

          // Spacer
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
