import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_docs/core/utils/environment.dart';
import 'package:spending_docs/features/scan/cubits/receipt_scan_image_state.dart';
import 'package:spending_docs/features/scan/data/datasources/gemini_receipt_scan_remote_data_source_impl.dart';
import 'package:spending_docs/features/scan/data/datasources/receipt_scan_remote_data_source.dart';
import 'package:spending_docs/features/scan/data/models/scanned_receipt_dto.dart';

class ReceiptScanImageCubit extends Cubit<ReceiptScanImageState> {
  final ReceiptScanRemoteDataSource _scanRemoteDataSource =
      GeminiReceiptScanRemoteDataSourceImpl(
        apiKey: Environment.geminiFreeApiKey,
      );

  ReceiptScanImageCubit() : super(ReceiptScanImageStateInitial());

  Future<void> processImage(Uint8List imageBytes) async {
    emit(ReceiptScanImageStateLoading());

    try {
      print('ScanCubit: Sending for scan');
      ScannedReceiptDto scannedReceiptDto = await _scanRemoteDataSource
          .analyzeReceiptImage(imageBytes);
      print('ScanCubit: Received answer: ${scannedReceiptDto.toString()}');
      emit(ReceiptScanImageStateReady(scannedReceiptDto: scannedReceiptDto));
    } catch (e) {
      print('ScanCubit: encountered error');
      emit(ReceiptScanImageStateError(error: e.toString()));
    }
  }
}
