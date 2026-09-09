class ScannedReceiptItemDto {
  double price;
  String itemName;

  ScannedReceiptItemDto({required this.price, required this.itemName});

  factory ScannedReceiptItemDto.fromJson(Map<String, dynamic> jsonData) {
    double priceValue = double.tryParse(jsonData['price'].toString()) ?? 0;
    String itemNameValue = jsonData['itemName'] ?? "";

    return ScannedReceiptItemDto(price: priceValue, itemName: itemNameValue);
  }
}
