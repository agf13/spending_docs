import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;
import 'package:spending_docs/core/database/app_database.dart' show Receipt;
import 'package:spending_docs/features/receipts/data/repositories/receipts_repository.dart'
    show ReceiptsRepository;
import 'package:spending_docs/features/receipts/presentation/widgets/receipt_delete_confirm.dart';
import 'package:spending_docs/features/receipts/presentation/widgets/receipt_form.dart';
import 'package:spending_docs/l10n/app_localizations.dart';

class ReceiptRow extends StatefulWidget {
  final Receipt receipt;
  const ReceiptRow({super.key, required this.receipt});

  @override
  State<ReceiptRow> createState() => _ReceiptRowState();
}

class _ReceiptRowState extends State<ReceiptRow> {
  late ColorScheme colorScheme;
  late TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    colorScheme = Theme.of(context).colorScheme;
    textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: colorScheme.outlineVariant, width: 1.0),
      ),
      child: cardDetails(context),
    );
  }

  Widget cardDetails(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [pressableChild(context), popupMenu(context)],
    );
  }

  Widget pressableChild(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: handleCardPress,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon
              leftIcon(context),

              // Spacer
              SizedBox(width: 10),

              // Main details (storeName, amount, date, card)
              mainDetails(context),
            ],
          ),
        ),
      ),
    );
  }

  void handleCardPress() {
    print('card tapped');
  }

  Widget leftIcon(BuildContext context) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: colorScheme.primaryContainer,
      child: Icon(Icons.receipt_long, color: colorScheme.onPrimaryContainer),
    );
  }

  Widget mainDetails(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Store name and price
          PriceAndStore(),

          // Card used and date
          DateAndCard(),
        ],
      ),
    );
  }

  Widget PriceAndStore() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Amount total
        detailBold(widget.receipt.amount.toString()),

        // Spacer
        SizedBox(width: 5),

        // Store name
        Expanded(child: detailBold(widget.receipt.storeName ?? '')),
      ],
    );
  }

  Widget DateAndCard() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Date
        Expanded(child: detail(dateFormat(widget.receipt.date))),

        // Spacer
        SizedBox(width: 5),

        // Card number or if it's cash
        detail(widget.receipt.card ?? ''),
      ],
    );
  }

  Widget detailBold(String text) {
    return Text(
      text,
      textAlign: TextAlign.right,
      overflow: TextOverflow.ellipsis,
      style: textTheme.titleMedium?.copyWith(
        color: colorScheme.onSurface,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget detail(String text) {
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: textTheme.bodyMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget popupMenu(BuildContext context) {
    return PopupMenuButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      itemBuilder: buildMenuOptions,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(Icons.more_vert),
      ),
    );
  }

  List<PopupMenuEntry<String>> buildMenuOptions(BuildContext context) {
    List<PopupMenuEntry<String>> menuOptions = [];
    menuOptions.add(editButton(context));
    menuOptions.add(deleteButton(context));

    return menuOptions;
  }

  PopupMenuItem<String> editButton(BuildContext context) {
    return PopupMenuItem(
      value: 'Edit',
      onTap: () => handleEdit(widget.receipt),
      child: Row(
        children: [
          Icon(Icons.edit),
          SizedBox(width: 10),
          Text(AppLocalizations.of(context)!.receiptCardMenuEdit),
        ],
      ),
    );
  }

  PopupMenuItem<String> deleteButton(BuildContext context) {
    return PopupMenuItem(
      value: 'Delete',
      onTap: handleDelete,
      child: Row(
        children: [
          Icon(Icons.delete),
          SizedBox(width: 10),
          Text(AppLocalizations.of(context)!.receiptCardMenuDelete),
        ],
      ),
    );
  }

  void handleEdit(Receipt? receipt) {
    ReceiptForm.showFormPopup(context: context, receipt: receipt);
  }

  void handleDelete() {
    ReceiptDeleteConfirm.showDeletePopup(
      context: context,
      receiptId: widget.receipt.id,
    );
  }

  String dateFormat(DateTime date) {
    const padSymbol = '0';

    String output = '';
    output += date.day.toString().padLeft(2, padSymbol);
    output += '-${date.month.toString().padLeft(2, padSymbol)}';
    output += '-${date.year}';
    output += ' ${date.hour.toString().padLeft(2, padSymbol)}';
    output += ':${date.minute.toString().padLeft(2, padSymbol)}';
    output += ':${date.second.toString().padLeft(2, padSymbol)}';

    return output;
  }
}
