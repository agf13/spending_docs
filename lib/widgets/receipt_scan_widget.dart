import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;
import 'package:mime/mime.dart';
import 'package:spending_docs/blocs/receipt_items_list_cubit.dart';
import 'package:spending_docs/blocs/receipts_list_cubit.dart';
import 'package:spending_docs/core/receipt_analysis/receipt_analysis_service.dart';
import 'package:spending_docs/repositories/receipt_items_repository.dart';
import 'package:spending_docs/repositories/receipts_repository.dart';

class ReceiptScanWidget extends StatefulWidget {
  const ReceiptScanWidget({super.key});

  @override
  State<StatefulWidget> createState() => _ReceiptScanWidgetState();
}

class _ReceiptScanWidgetState extends State<ReceiptScanWidget> {
  XFile? pickedFile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Scan button
        scanButton(context),
      ],
    );
  }

  Widget scanButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await handleScan(context);
      },
      child: Text('Choose photo'),
    );
  }

  Future<void> handleScan(BuildContext context) async {
    await pickPhoto();
    Map<String, dynamic>? json = await analyzeImage();

    if (json != null) {
      print('Extracting items');
      extractAndInsertElements(json, context);

      // Refresh the list of items
      await context.read<ReceiptsListCubit>().getItems();
      await context.read<ReceiptItemsListCubit>().getItems();
    } else {
      print('Json was null');
    }
  }

  Future<void> pickPhoto() async {
    const XTypeGroup typeGroup = XTypeGroup(
      label: 'images',
      extensions: <String>['jpg', 'jpeg', 'png', 'heic', 'webp'],
      mimeTypes: <String>['image/*'],
    );

    // Open the file dialog
    final XFile? file = await openFile(
      acceptedTypeGroups: <XTypeGroup>[typeGroup],
    );

    if (file == null) return;
    print('Receipt loaded');

    pickedFile = file;
  }

  Future<Map<String, dynamic>?> analyzeImage() async {
    print('Starting analysis');
    if (pickedFile == null) return null;
    final bytes = await _xFileToUint8List(pickedFile!);
    final mimeType = await mimeTypeFromXFile(pickedFile!);

    if (mimeType == null) return null;

    print('Wake up ai workflow');
    final analysisService = ReceiptAnalysizService();
    print('Analyze image');
    return await analysisService.analyzeReceiptImage(bytes, mimeType);
  }

  Future<void> extractAndInsertElements(
    Map<String, dynamic> json,
    BuildContext context,
  ) async {
    // Add receipt
    print('Extract receipt');
    final receiptCompanion = ReceiptAnalysizService.extractReceipt(json);

    // Return if the receiptCompanion cannot be extracted
    if (receiptCompanion == null) return;

    // Insert the receipt and store the id
    print('Insert receipt');
    final receiptId = await context.read<ReceiptsRepository>().add(
      receiptCompanion,
    );

    // Extract the list of items and prepare them with the receiptId as parent receipt id
    print('Extract items from receipt');
    final itemList = ReceiptAnalysizService.extractReceiptItems(
      json,
      receiptId,
    );

    // Add all elements to the database
    print('Insert all items from receipt');
    final receiptItemsRepository = context.read<ReceiptItemsRepository>();
    for (final item in itemList) {
      receiptItemsRepository.add(item);
    }
  }

  Future<Uint8List> _xFileToUint8List(XFile image) async {
    return await image.readAsBytes();
  }

  Future<String?> mimeTypeFromXFile(XFile file) async {
    if (file.mimeType != null && file.mimeType!.isNotEmpty) {
      return file.mimeType;
    }

    try {
      final Stream<List<int>> stream = file.openRead(0, 12);
      final List<int> headerBytes = await stream.first;

      return lookupMimeType(file.path, headerBytes: headerBytes) ??
          lookupMimeType(file.name);
    } catch (_) {
      return lookupMimeType(file.name);
    }
  }
}
