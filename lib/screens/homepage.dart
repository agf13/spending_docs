import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/cupertino.dart';
import 'package:spending_docs/blocs/receipt_list_cubit.dart';
import 'package:spending_docs/blocs/side_menu_cubit.dart';
import 'package:spending_docs/models/receipt_model.dart';
import 'package:spending_docs/widgets/receipt_filter_form.dart';
import 'package:spending_docs/widgets/receipt_form.dart';
import 'package:spending_docs/widgets/receipt_item.dart';
import 'package:spending_docs/widgets/side_menu.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  final _screenWidthFactor = 0.8;
  final _screenHeightFactor = 0.6;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My documenting app")),
      body: Stack(
        children: [
          // HomePage screen
          sideBarAndTable(context),

          // Create receipt form only displayed if needed
          sideMenuDisplayWidget(context),
        ],
      ),
    );
  }

  Widget sideBarAndTable(BuildContext context) {
    return Row(
      children: [
        // Side menu
        Expanded(
          flex: 1,
          child: Padding(padding: const EdgeInsets.all(8.0), child: SideMenu()),
        ),

        // List with items
        Expanded(
          flex: 5,
          child: BlocBuilder<ReceiptListCubit, List<ReceiptModel>>(
            builder: (context, itemList) {
              return ListView.builder(
                itemCount: itemList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ReceiptItem(receipt: itemList[index]),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget sideMenuOpenedWidget(BuildContext context, int buttonPressedIndex) {
    return switch (buttonPressedIndex) {
      0 => Container(), // Just empty widget
      1 => ReceiptForm(
        onClose: () {
          closeSideMenuDisplayedWidget(context);
        },
      ), // The add receipt form
      2 => ReceiptFilterForm(
        onClose: () {
          closeSideMenuDisplayedWidget(context);
        },
      ), // Set filter form
      _ => Container(), // Just empty widget
    };
  }

  Widget sideMenuDisplayWidget(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final buttonPressedIndex = context.watch<SideMenuCubit>().state;

    return Stack(
      children: [
        if (buttonPressedIndex != 0) ...[
          // Gesture detector to close the form
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              closeSideMenuDisplayedWidget(context);
            },
          ),

          // Widget opened from side menu
          Align(
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: screenWidth * _screenWidthFactor,
                maxHeight: screenHeight * _screenHeightFactor,
              ),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                color: Colors.amber,
                child: sideMenuOpenedWidget(context, buttonPressedIndex),
              ),
            ),
          ),
        ],
      ],
    );
  }

  void closeSideMenuDisplayedWidget(BuildContext context) {
    context.read<SideMenuCubit>().setSubMenuIndex(0);
  }

  void displayDatePicker(BuildContext context) {
    if (!kIsWeb && Platform.isIOS) {
      _selectCupertinoDate(context);
    } else {}
  }

  void _selectCupertinoDate(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: CupertinoDatePicker(
          mode: CupertinoDatePickerMode.dateAndTime,
          initialDateTime: DateTime.now(),
          onDateTimeChanged: (DateTime newDateTime) {
            // Handle live stream updates securely
          },
        ),
      ),
    );
  }

  Future<void> _selectMaterialDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      // Security/Reliability tip: Strictly prevent bad inputs
      selectableDayPredicate: (DateTime val) => val.weekday != DateTime.sunday,
    );
    if (picked != null) {
      // Process your secure timestamp here
    }
  }
}
