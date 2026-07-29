import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;
import 'package:mime/mime.dart';
import 'package:spending_docs/blocs/receipt_items_list_cubit.dart';
import 'package:spending_docs/blocs/receipts_list_cubit.dart';
import 'package:spending_docs/core/receipt_analysis/receipt_analysis_service.dart';
import 'package:spending_docs/database/app_database.dart'
    show Receipt, ReceiptItem;
import 'package:spending_docs/repositories/receipt_items_repository.dart';
import 'package:spending_docs/repositories/receipts_repository.dart';

class ReceiptScanWidget extends StatefulWidget {
  const ReceiptScanWidget({super.key});

  @override
  State<StatefulWidget> createState() => _ReceiptScanWidgetState();
}

class _ReceiptScanWidgetState extends State<ReceiptScanWidget> {
  XFile? _pickedFile;

  Receipt? receipt;
  List<ReceiptItem> itemList = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .center,
      crossAxisAlignment: .center,
      mainAxisSize: .min,
      children: [
        // Scan button
        scanButton(context),

        // Spacer
        SizedBox(height: 10),

        // Preview of scanned receipt
        previewReceipt(context),
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

  Widget previewReceipt(BuildContext context) {
    if (receipt != null) {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: .start,
          crossAxisAlignment: .start,
          mainAxisSize: .min,
          children: [
            // Receipt
            ...receiptAsText(context),

            // Separator
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 200),
              child: Divider(color: Colors.red),
            ),

            // Receipt items
            ...receiptItemsAsText(context),
          ],
        ),
      );
    }

    return SizedBox.shrink();
  }

  List<Widget> receiptAsText(BuildContext context) {
    List<Widget> widgets = [];
    if (receipt != null) {
      widgets.add(oneRowLine('Amount:', receipt!.amount.toString()));
      widgets.add(oneRowLine('StoreName:', receipt!.storeName ?? ''));
      widgets.add(oneRowLine('Date', receipt!.date.toString()));
      widgets.add(oneRowLine('Card', receipt!.card ?? ''));
    }

    return widgets;
  }

  List<Widget> receiptItemsAsText(context) {
    List<Widget> widgets = [];
    for (var item in itemList) {
      widgets.add(oneRowLine('ItemName:', item.itemName));
      widgets.add(oneRowLine('Price:', item.price.toString()));
    }

    return widgets;
  }

  Widget oneRowLine(String label, String value) {
    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: .start,
        crossAxisAlignment: .start,
        mainAxisSize: .min,
        children: [Text(label), SizedBox(width: 10, height: 10), Text(value)],
      ),
    );
  }

  Future<void> handleScan(BuildContext context) async {
    await pickPhoto();
    Map<String, dynamic>? json = await analyzeImage();

    if (json != null) {
      await insertItems(json, context);
      await refreshLists(context);
    }
  }

  Future<void> refreshLists(BuildContext context) async {
    await context.read<ReceiptsListCubit>().getItems();
    await context.read<ReceiptItemsListCubit>().getItems();
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

    _pickedFile = file;
  }

  Future<Map<String, dynamic>?> analyzeImage() async {
    print('Starting analysis');
    if (_pickedFile == null) return null;
    final bytes = await _xFileToUint8List(_pickedFile!);
    final mimeType = await mimeTypeFromXFile(_pickedFile!);

    if (mimeType == null) return null;

    print('Wake up ai workflow');
    final analysisService = ReceiptAnalysizService();
    print('Analyze image');
    return await analysisService.analyzeReceiptImage(bytes, mimeType);
  }

  Future<void> insertItems(
    Map<String, dynamic> json,
    BuildContext context,
  ) async {
    // Add receipt
    final receiptCompanion = ReceiptAnalysizService.extractReceipt(json);
    if (receiptCompanion == null) return;

    final receiptId = await context.read<ReceiptsRepository>().add(
      receiptCompanion,
    );

    // Extract the list of items and prepare them with the receiptId as parent receipt id
    final itemListCompanion = ReceiptAnalysizService.extractReceiptItems(
      json,
      receiptId,
    );

    final receiptItemsRepository = context.read<ReceiptItemsRepository>();
    for (final item in itemListCompanion) {
      receiptItemsRepository.add(item);
    }

    // Prepare preview items
    receipt = await context.read<ReceiptsRepository>().getById(receiptId);
    itemList = await context.read<ReceiptItemsRepository>().getByReceiptId(
      receipt!.id,
    );

    setState(() {
      receipt = receipt;
      itemList = itemList;
    });
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
