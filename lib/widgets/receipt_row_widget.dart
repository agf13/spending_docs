/*
  The widget to display information about a receipt
*/

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_docs/blocs/popup_widget_cubit.dart';
import 'package:spending_docs/blocs/receipts_list_cubit.dart';
import 'package:spending_docs/database/app_database.dart' show Receipt;
import 'package:spending_docs/models/popup_menu_enum.dart';

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
      color: Colors.yellowAccent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Properties of receipt in a clickable area
          clickableList(context),

          // Delete button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                _handleDelete(context);
              },
              icon: Icon(Icons.delete),
            ),
          ),
        ],
      ),
    );
  }

  Widget clickableList(BuildContext context) {
    return Material(
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
    return Padding(padding: const EdgeInsets.all(8.0), child: Text(property));
  }

  void _handleDelete(BuildContext context) {
    context.read<ReceiptsListCubit>().removeItem(widget.receipt.id);
  }
}
