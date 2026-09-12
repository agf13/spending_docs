import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_docs/features/scan/cubits/receipt_scan_image_cubit.dart';
import 'package:spending_docs/features/scan/cubits/receipt_scan_image_state.dart';
import 'package:spending_docs/features/scan/data/models/scanned_receipt_dto.dart';
import 'package:spending_docs/features/scan/data/models/scanned_receipt_item_dto.dart';
import 'package:spending_docs/features/scan/presentation/widgets/review_scan.dart';

class ScanForm {
  static void showScanResultModalBottomSheet({
    required BuildContext context,
    ScannedReceiptDto? receiptDto,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return ScanFormBody(receiptDto: receiptDto);
      },
    );
  }
}

class ScanFormBody extends StatefulWidget {
  final ScannedReceiptDto? receiptDto;

  const ScanFormBody({super.key, this.receiptDto});

  @override
  State<ScanFormBody> createState() => _ScanFormBodyState();
}

class _ScanFormBodyState extends State<ScanFormBody> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: formBody(),
    );
  }

  Widget formBody() {
    return BlocBuilder<ReceiptScanImageCubit, ReceiptScanImageState>(
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
    return FractionallySizedBox(
      heightFactor: 0.5,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: SingleChildScrollView(
            child: Text(
              errorString,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget showResult(ScannedReceiptDto scannedReceiptDto) {
    return ReviewScan(scannedReceiptDto: scannedReceiptDto);
  }

  Widget defaultText() {
    return FractionallySizedBox(
      heightFactor: 0.5,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Text(
            'Weird result. Contact the programmer if you manage to recreate this text',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
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
