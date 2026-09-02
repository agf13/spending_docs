import 'dart:typed_data';

import 'package:spending_docs/features/scan/data/models/scanned_receipt_dto.dart';

abstract class ReceiptScanRemoteDataSource {
  Future<ScannedReceiptDto> analyzeReceiptImage(Uint8List imageBytes);
}
