import 'package:spending_docs/models/receipt_model.dart';

void main() {
  ReceiptModel model = ReceiptModel(
    amount: 100.3,
    date: DateTime.parse("2026-01-13 12:30:02"),
    isCash: true,
    storeName: "Carrefour",
    cardNumber: "1234",
  );

  final modelCsv = model.toCsv();
  print(modelCsv);

  final modelFromCsv = ReceiptModel.fromCsv(modelCsv);
  modelFromCsv?.cardNumber = "other city";

  print(modelFromCsv != null ? modelFromCsv.toCsv() : "could not convert");
}
