import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;
import 'package:spending_docs/features/receipts/blocs/receipt_list_bloc.dart';
import 'package:spending_docs/features/receipts/data/repositories/receipts_repository.dart';
import 'package:spending_docs/l10n/app_localizations.dart';

class ReceiptDeleteConfirm {
  static void showDeletePopup({
    required BuildContext context,
    required int receiptId,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeletePopup(receiptId: receiptId);
      },
    );
  }
}

class DeletePopup extends StatelessWidget {
  final int receiptId;
  const DeletePopup({super.key, required this.receiptId});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: dialogBody(context),
      ),
    );
  }

  Widget dialogBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        confirmationTitle(context),
        SizedBox(height: 20),
        confirmationButtons(context),
      ],
    );
  }

  Widget confirmationTitle(BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.confirmationPopupDeleteReceiptTile,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }

  Widget confirmationButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [confirmButton(context), SizedBox(width: 10), cancelButton(context)],
    );
  }

  Widget genericButton({
    required BuildContext context,
    required String label,
    required Function() onPressed,
  }) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget confirmButton(BuildContext context) {
    return genericButton(
      context: context,
      label: AppLocalizations.of(context)!.confirmationPopupDelete,
      onPressed: () => onDelete(context),
    );
  }

  Widget cancelButton(BuildContext context) {
    return genericButton(
      context: context,
      label: AppLocalizations.of(context)!.confirmationPopupCancel,
      onPressed: () => onCancel(context),
    );
  }

  void onDelete(BuildContext context) {
    context.read<ReceiptsRepository>().remove(receiptId);
    context.read<ReceiptListBloc>().add(ReceiptRefresh());
    Navigator.of(context).pop();
  }

  void onCancel(BuildContext context) {
    Navigator.of(context).pop();
  }
}
