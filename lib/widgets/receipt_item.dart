import 'dart:typed_data' show Uint8List;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_docs/blocs/receipts_list_cubit.dart';
import 'package:spending_docs/core/receipt_analysis/receipt_analysiz_service.dart';
import 'package:spending_docs/database/app_database.dart' show Receipt;

class ReceiptItem extends StatefulWidget {
  final Receipt receipt;

  const ReceiptItem({super.key, required this.receipt});

  @override
  State<ReceiptItem> createState() {
    return _ReceiptItemState();
  }
}

class _ReceiptItemState extends State<ReceiptItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellowAccent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Amount
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.receipt.amount.toString()),
            ),
          ),

          // Date
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.receipt.date.toString()),
            ),
          ),

          // Store
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.receipt.storeName ?? ""),
            ),
          ),

          // Card number
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(widget.receipt.card ?? ""),
            ),
          ),

          // Parse receipt from image button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () async {
                _handleImage(context);
              },
              icon: Icon(Icons.center_focus_strong),
            ),
          ),

          // Delete button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              onPressed: () {
                _handleDelete(context);
              },
              icon: Icon(Icons.delete),
            ),
          ),
        ],
      ),
    );
  }

  void _handleDelete(BuildContext context) {
    context.read<ReceiptsListCubit>().removeItem(widget.receipt.id);
  }

  void _handleImage(BuildContext context) async {
    try {
      final FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.image,
        allowMultiple: false,
        withData: true,
        );

      if (result == null || result.files.isEmpty) { return null; }

      final file = result.files.first;
      final Uint8List? fileBytes = file.bytes;

      if(fileBytes == null) {throw Exception('Failed to read file bytes into memory');}

      final extension = file.extension?.toLowerCase() ?? 'jpeg';
      final String computedMimeType = 'image/$extension';

      processByAi(fileBytes, computedMimeType);
    } catch (e) {
      print('Error picking or processing image: ${e.toString()}');
    }
  }

  void processByAi(Uint8List imageBytes, String mimeType) async {
    final analysisService = ReceiptAnalysizService();
    analysisService.analyzeReceiptImage(imageBytes, mimeType);

  }
}
