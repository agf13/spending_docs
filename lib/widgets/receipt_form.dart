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

    _years = List.generate(50, (index) {
      return (1990 + index);
    });
    _months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
    _days = List.generate(getDaysInMonth(_year, _month), (index) {
      return 1 + index;
    });
    _hours = List.generate(24, (index) {
      return index;
    });
    _minutes = List.generate(60, (index) {
      return index;
    });
    _seconds = List.generate(60, (index) {
      return index;
    });
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
      final date = DateTime.parse(
        "$_year-$_month-$_day $_hour:$_minute:$_second",
      );

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
        wheelPicker(items: _years, title: 'Year', width: width, height: height),

        // Spacer
        SizedBox(width: 5),

        // Month wheel
        wheelPicker(
          items: _months,
          title: 'Month',
          width: width,
          height: height,
        ),

        // Spacer
        SizedBox(width: 5),

        // Day wheel
        wheelPicker(items: _days, title: 'Day', width: width, height: height),

        // Spacer
        SizedBox(width: 5),

        // Hour wheel
        wheelPicker(items: _hours, title: 'Hour', width: width, height: height),

        // Spacer
        SizedBox(width: 5),

        // Minute wheel
        wheelPicker(
          items: _minutes,
          title: 'Minute',
          width: width,
          height: height,
        ),

        // Spacer
        SizedBox(width: 5),

        // Second wheel
        wheelPicker(
          items: _seconds,
          title: 'Second',
          width: width,
          height: height,
        ),
      ],
    );
  }

  Widget wheelPicker({
    required List items,
    required String title,
    required double width,
    required double height,
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
            itemExtent: 20,
            useMagnifier: true,
            magnification: 1.2,
            onSelectedItemChanged: (index) {
              print('$index - ${items[index]}');
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

  int getDaysInMonth(int year, int month) {
    return DateUtils.getDaysInMonth(year, month);
  }
}
