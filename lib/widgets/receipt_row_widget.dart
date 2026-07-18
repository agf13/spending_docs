/*
  The widget to display information about a receipt
*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_docs/blocs/popup_widget_cubit.dart';
import 'package:spending_docs/blocs/receipts_list_cubit.dart';
import 'package:spending_docs/database/app_database.dart' show Receipt;

class ReceiptRowWidget extends StatefulWidget {
  final Receipt receipt;

  const ReceiptRowWidget({super.key, required this.receipt});

  @override
  State<ReceiptRowWidget> createState() {
    return _ReceiptRowWidgetState();
  }
}

class _ReceiptRowWidgetState extends State<ReceiptRowWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.yellowAccent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Properties of receipt in a clickable area
          clickableList(context),

          // Spacer
          SizedBox(width: 10),

          // Delete button
          deleteButton(context),
        ],
      ),
    );
  }

  Widget clickableList(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          context.read<PopupWidgetCubit>().setPopupWidgetReceiptItems(
            widget.receipt.id,
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Amount
            propertyDisplay(widget.receipt.amount.toString()),

            // Date
            propertyDisplay(widget.receipt.date.toString()),

            // Store
            propertyDisplay(widget.receipt.storeName ?? ""),

            // Card number
            propertyDisplay(widget.receipt.card ?? ""),
          ],
        ),
      ),
    );
  }

  Widget propertyDisplay(String property) {
    return Expanded(
      child: Padding(padding: const EdgeInsets.all(8.0), child: Text(property)),
    );
  }

  Widget deleteButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        onPressed: () {
          _handleDelete(context);
        },
        icon: Icon(Icons.delete),
      ),
    );
  }

  void _handleDelete(BuildContext context) {
    context.read<ReceiptsListCubit>().removeItem(widget.receipt.id);
  }
}
