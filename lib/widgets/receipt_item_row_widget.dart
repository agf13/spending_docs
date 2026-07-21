/*
  Display one item from a receipt
*/

import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:spending_docs/blocs/receipt_items_list_cubit.dart";
import "package:spending_docs/database/app_database.dart" show ReceiptItem;
import "package:spending_docs/widgets/receipt_item_form.dart";

class ReceiptItemRowWidget extends StatefulWidget {
  final ReceiptItem receiptItem;

  const ReceiptItemRowWidget({super.key, required this.receiptItem});

  @override
  State<ReceiptItemRowWidget> createState() => _ReceiptItemRowWidgetState();
}

class _ReceiptItemRowWidgetState extends State<ReceiptItemRowWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Show item fields
          itemFields(context),

          // Spacer
          SizedBox(width: 10),

          // Delete button
          ...buttons(context),
        ],
      ),
    );
  }

  Widget itemFields(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Show item name
          itemNameWidget(),

          // Show price
          priceWidget(),
        ],
      ),
    );
  }

  Widget itemNameWidget() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(widget.receiptItem.itemName),
      ),
    );
  }

  Widget priceWidget() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(widget.receiptItem.price.toString()),
      ),
    );
  }

  List<Widget> buttons(BuildContext context) {
    return [
      // Edit button
      editButton(context),

      // Delete button
      deleteButton(context),
    ];
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
    context.read<ReceiptItemsListCubit>().removeItem(widget.receiptItem.id);
  }

  Widget editButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: IconButton(
        onPressed: () {
          _handleEditDialog(context);
        },
        icon: Icon(Icons.edit),
      ),
    );
  }

  void _handleEditDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit item'),
          content: ReceiptItemForm(
            receiptId: widget.receiptItem.receiptId,
            id: widget.receiptItem.id,
            itemName: widget.receiptItem.itemName,
            price: widget.receiptItem.price,
          ),
          actions: [],
        );
      },
    );
  }
}
