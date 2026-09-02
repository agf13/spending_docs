import 'package:flutter/material.dart';
import 'package:spending_docs/features/scan/data/models/scanned_receipt_dto.dart';

class ScanReceiptResult extends StatefulWidget {
  final ScannedReceiptDto scannedReceiptDto;

  const ScanReceiptResult({super.key, required this.scannedReceiptDto});
  
  @override
  State<ScanReceiptResult> createState() => _ScanReceiptResultState();
}

class _ScanReceiptResultState extends State<ScanReceiptResult> {

  @override
  Widget build(BuildContext context) {
    return 
  }
}
