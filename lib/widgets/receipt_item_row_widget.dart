/*
  Display one item from a receipt
*/

import "package:flutter/material.dart";
import "package:spending_docs/database/app_database.dart" show ReceiptItem;

class ReceiptItemRowWidget extends StatelessWidget {
  final ReceiptItem receiptItem;

  const ReceiptItemRowWidget({super.key, required this.receiptItem});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Show item name
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(receiptItem.itemName),
            ),
          ),

          // Show price
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(receiptItem.price.toString()),
            ),
          ),
        ],
      ),
    );
  }
}
