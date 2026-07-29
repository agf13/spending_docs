import 'package:spending_docs/database/app_database.dart' show ReceiptItem;

class ReceiptModel {
  final bool isCashPayment;
  final String? cardLast4Digits;
  final double total;
  final List<ReceiptItem> items;

  ReceiptModel({
    required this.isCashPayment,
    this.cardLast4Digits,
    required this.total,
    required this.items,
  });
}
