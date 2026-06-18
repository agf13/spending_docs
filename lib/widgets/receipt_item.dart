import 'package:flutter/material.dart';
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
        ],
      ),
    );
  }
}
