import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_docs/blocs/receipt_list_cubit.dart';
import 'package:spending_docs/models/receipt_model.dart';

class ReceiptItem extends StatefulWidget {
  final ReceiptModel receipt;

  const ReceiptItem({super.key, required this.receipt});

  @override
  State<ReceiptItem> createState() {
    return _ReceiptItemState();
  }
}

class _ReceiptItemState extends State<ReceiptItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellowAccent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Amount
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.receipt.amount.toString()),
            ),
          ),

          // Date
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.receipt.date.toString()),
            ),
          ),

          // Store
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.receipt.storeName),
            ),
          ),

          // Card number
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.receipt.cardNumber),
            ),
          ),

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

  void _handleDelete(BuildContext context) {
    context.read<ReceiptListCubit>().removeItem(widget.receipt);
  }
}
