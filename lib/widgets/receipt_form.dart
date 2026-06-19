import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:spending_docs/blocs/receipt_list_cubit.dart';
import 'package:spending_docs/helpers/conversion.dart';
import 'package:spending_docs/models/receipt_model.dart';
import 'package:spending_docs/widgets/item_text_input.dart';

class ReceiptForm extends StatefulWidget {
  final VoidCallback onClose;

  const ReceiptForm({super.key, required this.onClose});

  @override
  State<ReceiptForm> createState() {
    return _ReceiptFormState();
  }
}

class _ReceiptFormState extends State<ReceiptForm> {
  final _formKey = GlobalKey<FormState>();

  final _amountTextController = TextEditingController();
  final _storeNameTextController = TextEditingController();
  final _cardNumberTextController = TextEditingController();

  late final FixedExtentScrollController _yearScrollController;
  late final FixedExtentScrollController _monthScrollController;
  late final FixedExtentScrollController _dayScrollController;
  late final FixedExtentScrollController _hourScrollController;
  late final FixedExtentScrollController _minuteScrollController;
  late final FixedExtentScrollController _secondScrollController;

  final _startYear = 1990;
  final _numberYears = 50;
  int _year = 2000;
  int _month = 1;
  int _day = 1;
  int _hour = 0;
  int _minute = 0;
  int _second = 0;
  List<int> _years = [];
  List<int> _months = [];
  List<int> _days = [];
  List<int> _hours = [];
  List<int> _minutes = [];
  List<int> _seconds = [];

  @override
  void initState() {
    super.initState();

    final currentDate = DateTime.now();
    _year = currentDate.year;
    _month = currentDate.month;
    _day = currentDate.day;
    _hour = currentDate.hour;
    _minute = currentDate.minute;
    _second = currentDate.second;

    _years = List.generate(_numberYears, (index) {
      return (_startYear + index);
    });
    _months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
    _setListDays(); // Set the list of days
    _hours = List.generate(24, (index) {
      return index;
    });
    _minutes = List.generate(60, (index) {
      return index;
    });
    _seconds = List.generate(60, (index) {
      return index;
    });

    _setWheelsInitialItems();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Input for amount
            ItemTextInput(
              labelText: 'Amount (123.45)',
              hintText: '',
              textController: _amountTextController,
              prefixIcon: Icon(Icons.money),
              keyboardType: TextInputType.text,
              validationFunction: validateAmount,
            ),

            // Input for the name of store
            ItemTextInput(
              labelText: 'Store name',
              hintText: '',
              textController: _storeNameTextController,
              prefixIcon: Icon(Icons.store),
              keyboardType: TextInputType.text,
              validationFunction: validateSoreName,
            ),

            // Input for card last 4 digits
            ItemTextInput(
              labelText: 'Card number last 4 digits (1234)',
              hintText: '',
              textController: _cardNumberTextController,
              prefixIcon: Icon(Icons.credit_card),
              keyboardType: TextInputType.text,
              validationFunction: validateCardNumber,
            ),

            // Spacer
            const SizedBox(height: 10),

            // Picker
            _displayDatePicker(context),

            // Submit button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Some space
                  Spacer(flex: 1),

                  // Close button
                  ElevatedButton(
                    onPressed: widget.onClose,
                    child: Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: Icon(Icons.close),
                    ),
                  ),

                  // Some space
                  Spacer(flex: 1),

                  // Confirm and add button
                  ElevatedButton(
                    onPressed: () => handleAddFormButton(context),
                    child: Padding(
                      padding: const EdgeInsets.all(11.0),
                      child: Icon(Icons.check),
                    ),
                  ),

                  // Some space
                  Spacer(flex: 1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? validateAmount(String? text) {
    if (text == null || text.isEmpty) return "Amount needed";
    if (Conversion.textToDouble(text) == null) return "Needs to be a number";
    return null;
  }

  String? validateDate(String? text) {
    if (text == null || text.isEmpty) return "Date needed";
    if (Conversion.textToDateTime(text) == null) return "Needs a proper date";
    return null;
  }

  String? validateSoreName(String? text) {
    return null; // Store name can be missing. null means no error text to show
  }

  String? validateCardNumber(String? text) {
    return null; // Card can be missing. Null means no error text to show
  }

  void handleAddFormButton(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final amount = Conversion.textToDouble(_amountTextController.text);
      final storeName = _storeNameTextController.text;
      final cardNumber = _cardNumberTextController.text;
      final date = DateTime(_year, _month, _day, _hour, _minute, _second);

      if (amount == null) return;

      ReceiptModel receipt = ReceiptModel(
        amount: amount,
        date: date,
        storeName: storeName,
        cardNumber: cardNumber,
      );

      context.read<ReceiptListCubit>().addItem(receipt);
    }
  }

  Widget _displayDatePicker(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.1;
    final height = MediaQuery.of(context).size.height * 0.1;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Year wheel
        wheelPicker(
          items: _years,
          title: 'Year',
          width: width,
          height: height,
          onValueChanged: _onYearChanged,
          controller: _yearScrollController,
        ),

        // Spacer
        SizedBox(width: 5),

        // Month wheel
        wheelPicker(
          items: _months,
          title: 'Month',
          width: width,
          height: height,
          onValueChanged: _onMonthChanged,
          controller: _monthScrollController,
        ),

        // Spacer
        SizedBox(width: 5),

        // Day wheel
        wheelPicker(
          items: _days,
          title: 'Day',
          width: width,
          height: height,
          onValueChanged: _onDayChanged,
          controller: _dayScrollController,
        ),

        // Spacer
        SizedBox(width: 5),

        // Hour wheel
        wheelPicker(
          items: _hours,
          title: 'Hour',
          width: width,
          height: height,
          onValueChanged: _onHourChanged,
          controller: _hourScrollController,
        ),

        // Spacer
        SizedBox(width: 5),

        // Minute wheel
        wheelPicker(
          items: _minutes,
          title: 'Minute',
          width: width,
          height: height,
          onValueChanged: _onMinuteChanged,
          controller: _minuteScrollController,
        ),

        // Spacer
        SizedBox(width: 5),

        // Second wheel
        wheelPicker(
          items: _seconds,
          title: 'Second',
          width: width,
          height: height,
          onValueChanged: _onSecondChanged,
          controller: _secondScrollController,
        ),
      ],
    );
  }

  Widget wheelPicker({
    required List items,
    required String title,
    required double width,
    required double height,
    required void Function(int) onValueChanged,
    required FixedExtentScrollController controller,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // The description of the wheel picker
        Text(title),
        // Some space
        const SizedBox(height: 10),
        // The wheel picked
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 2),
          ),
          child: ListWheelScrollView(
            controller: controller,
            itemExtent: 20,
            useMagnifier: true,
            magnification: 1.2,
            onSelectedItemChanged: (index) {
              onValueChanged(items[index]);
            },
            physics: const FixedExtentScrollPhysics(),
            children: items.map((element) {
              return Center(child: Text(element.toString()));
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _setWheelsInitialItems() {
    final yearIndex = _getYearIndexInListOfAvailableYears(_year);
    _yearScrollController = FixedExtentScrollController(initialItem: yearIndex);
    _monthScrollController = FixedExtentScrollController(
      initialItem: _month - 1,
    );
    _dayScrollController = FixedExtentScrollController(initialItem: _day - 1);
    _hourScrollController = FixedExtentScrollController(initialItem: _hour);
    _minuteScrollController = FixedExtentScrollController(initialItem: _minute);
    _secondScrollController = FixedExtentScrollController(initialItem: _second);
  }

  void _setListDays() {
    final daysInMonth = DateUtils.getDaysInMonth(_year, _month);

    if (_day > daysInMonth) {
      _day = daysInMonth;
    }

    final _newListDays = List.generate(daysInMonth, (index) {
      return 1 + index;
    });

    setState(() {
      _days = _newListDays;
    });
  }

  void _onYearChanged(int newYear) {
    _year = newYear;
    _setListDays();
  }

  void _onMonthChanged(int newMonth) {
    _month = newMonth;
    _setListDays();
  }

  void _onDayChanged(int newDay) {
    _day = newDay;
  }

  void _onHourChanged(int newHour) {
    _hour = newHour;
  }

  void _onMinuteChanged(int newMinute) {
    _minute = newMinute;
  }

  void _onSecondChanged(int newSecond) {
    _second = newSecond;
  }

  int _getYearIndexInListOfAvailableYears(int year) {
    if (year < _startYear || year > _startYear + _numberYears) return -1;
    return year - _startYear;
  }
}
