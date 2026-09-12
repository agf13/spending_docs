import 'package:spending_docs/features/scan/data/models/scanned_receipt_dto.dart';

class ReceiptScanImageState {}

class ReceiptScanImageStateInitial extends ReceiptScanImageState {}

class ReceiptScanImageStateLoading extends ReceiptScanImageState {}

class ReceiptScanImageStateReady extends ReceiptScanImageState {
  final ScannedReceiptDto scannedReceiptDto;

  ReceiptScanImageStateReady({required this.scannedReceiptDto});
}

class ReceiptScanImageStateError extends ReceiptScanImageState {
  final String error;

  ReceiptScanImageStateError({required this.error});
}
