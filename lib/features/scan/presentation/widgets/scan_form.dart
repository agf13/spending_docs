import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_docs/features/scan/cubits/receipt_scan_image_cubit.dart';
import 'package:spending_docs/features/scan/cubits/receipt_scan_image_state.dart';
import 'package:spending_docs/features/scan/data/models/scanned_receipt_dto.dart';
import 'package:spending_docs/features/scan/data/models/scanned_receipt_item_dto.dart';

class ScanForm {
  static void showScanResultPopup({
    required BuildContext context,
    ScannedReceiptDto? receiptDto,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ScanFormBody(receiptDto: receiptDto);
      },
    );
  }
}

class ScanFormBody extends StatefulWidget {
  final ScannedReceiptDto? receiptDto;

  ScanFormBody({super.key, this.receiptDto});

  @override
  State<ScanFormBody> createState() => _ScanFormBodyState();
}

class _ScanFormBodyState extends State<ScanFormBody> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      child: BlocBuilder<ReceiptScanImageCubit, ReceiptScanImageState>(
        builder: (context, state) {
          if (state is ReceiptScanImageStateLoading) {
            return showLoadingSpinner();
          } else if (state is ReceiptScanImageStateError) {
            return showError(state.error);
          } else if (state is ReceiptScanImageStateReady) {
            return showResult(state.scannedReceiptDto);
          } else {
            return defaultText();
          }
        },
      ),
    );
  }

  Widget showLoadingSpinner() {
    return SizedBox(
      width: 100,
      height: 100,
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget showError(String errorString) {
    return SizedBox(
      width: 200,
      height: 100,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: SingleChildScrollView(
            child: Text(
              errorString,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget showResult(ScannedReceiptDto scannedReceiptDto) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SingleChildScrollView(child: Text(scannedReceiptDto.toString())),
        Text(scannedReceiptDto.amount.toString()),
        Text(scannedReceiptDto.storeName ?? "not store"),
        Text(scannedReceiptDto.card),
        Text(scannedReceiptDto.date.toString()),
        Flexible(child: listReceiptItems(scannedReceiptDto.receiptItemList)),
        ElevatedButton(
          onPressed: () {
            print('button pressed');
          },
          child: Text('close'),
        ),
      ],
    );
  }

  Widget defaultText() {
    return SizedBox(
      height: 100,
      width: 200,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Text(
            'Weird result. Contact the programmer if you manage to recreate this text',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget listReceiptItems(List<ScannedReceiptItemDto> receiptItemsList) {
    return ListView.builder(
      itemCount: receiptItemsList.length,
      itemBuilder: (_, index) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(receiptItemsList[index].price.toString()),
            SizedBox(width: 10),
            Text(receiptItemsList[index].itemName),
          ],
        );
      },
    );
  }
}
