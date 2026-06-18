import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:spending_docs/models/receipt_model.dart';

class ReceiptStorageSupportDirectory {
  /*
    def: Get the path to the file handling the storage for receipt items.
    in: -
    out: File object
  */
  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/receipt_list.csv');
  }

  Future<List<ReceiptModel>> readAll() async {
    try {
      final file = await _getFile(); // Should create file if unexistent
      if (!await file.exists()) return []; // If no file then return empty list

      // Read all data
      final String data = await file.readAsString();

      // Convert data to list of receipts
      return _receiptListFromCsvData(data);
    } catch (e) {
      return [];
    }
  }

  Future<bool> add(ReceiptModel receipt) async {
    final items = await readAll();

    if (await _isDuplicate(receipt, items)) {
      return false;
    }

    items.add(receipt);
    saveAll(items);
    return true;
  }

  Future<void> update(ReceiptModel receipt) async {
    final items = await readAll();

    for (int index = 0; index < items.length; index++) {
      if (ReceiptModel.isSame(items[index], receipt)) {
        items[index].amount = receipt.amount;
        items[index].cardNumber = receipt.cardNumber;

        await saveAll(items);
        return;
      }
    }
  }

  Future<void> delete(ReceiptModel receipt) async {
    final items = await readAll();
    items.removeWhere(
      (currentReceipt) => ReceiptModel.isSame(currentReceipt, receipt),
    );

    await saveAll(items);
  }

  Future<File> saveAll(List<ReceiptModel> receiptList) async {
    final file = await _getFile();

    String data = _receiptListToString(receiptList);

    return file.writeAsString(data);
  }

  List<ReceiptModel> _receiptListFromCsvData(String data) {
    // Split data in a list of strings
    final List<String> csvList = LineSplitter().convert(data);

    // Init empty list
    List<ReceiptModel> receiptList = [];

    // For every line convert it to ReceiptModel and store it in a result listi
    for (String line in csvList) {
      // Convert from CSV to model
      final newReceipt = ReceiptModel.fromCsv(line);

      // Append model if existent
      if (newReceipt != null) {
        receiptList.add(newReceipt);
      }
    }

    return receiptList;
  }

  String _receiptListToString(List<ReceiptModel> receiptList) {
    String receiptListAsText = '';

    for (ReceiptModel receipt in receiptList) {
      final receiptAsCsv = receipt.toCsv();
      receiptListAsText += "$receiptAsCsv${Platform.lineTerminator}";
    }

    return receiptListAsText;
  }

  Future<bool> _isDuplicate(
    ReceiptModel receipt,
    List<ReceiptModel>? list,
  ) async {
    // Ensure the list contains the Receipt data
    list = list ?? await readAll();

    // Iterate the list and check for duplicate
    for (ReceiptModel currentReceipt in list) {
      if (ReceiptModel.isSame(currentReceipt, receipt)) {
        return true;
      }
    }

    return false; // No duplicate found
  }
}
