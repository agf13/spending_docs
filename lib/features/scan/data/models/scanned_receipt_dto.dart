import 'package:spending_docs/features/scan/data/models/scanned_receipt_item_dto.dart';

class ScannedReceiptDto {
  final double amount;
  final String? storeName;
  final String card;
  final DateTime date;

  final List<ScannedReceiptItemDto> receiptItemList;

  ScannedReceiptDto({
    required this.amount,
    this.storeName,
    required this.card,
    required this.date,
    required this.receiptItemList,
  });

  factory ScannedReceiptDto.fromJson(Map<String, dynamic> jsonData) {
    // Extract receipt parameters
    double amountValue = double.tryParse(jsonData['amount'].toString()) ?? 0;
    String? storeNameValue = jsonData['storeName'] ?? "";
    String cardValue = jsonData['card'] ?? "";
    DateTime dateValue =
        DateTime.tryParse(jsonData["date"].toString()) ??
        DateTime.parse("1990-01-01 00:00:00");
    List<ScannedReceiptItemDto> listItemsDto = [];

    // Extract items
    if (jsonData['items'] != null) {
      try {
        final listItems = jsonData['items'] as List<dynamic>;

        for (final item in listItems) {
          ScannedReceiptItemDto newItem = ScannedReceiptItemDto.fromJson(
            item as Map<String, dynamic>,
          );
          listItemsDto.add(newItem);
        }
      } catch (e) {
        print("Error while trying to read receipt items: $e");
      }
    }

    // Create and return the object
    return ScannedReceiptDto(
      amount: amountValue,
      storeName: storeNameValue,
      card: cardValue,
      date: dateValue,
      receiptItemList: listItemsDto,
    );
  }
}
