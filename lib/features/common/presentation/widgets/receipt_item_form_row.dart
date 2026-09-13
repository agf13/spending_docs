import 'package:flutter/material.dart';
import 'package:spending_docs/features/common/presentation/widgets/generic_input_field.dart';
import 'package:spending_docs/features/receipt_items/domain/receipt_item_validator.dart';
import 'package:spending_docs/l10n/app_localizations.dart';

class ReceiptItemFormRow extends StatefulWidget {
  final String price;
  final String itemName;
  final VoidCallback? onRemove;
  final Function(String?)? onItemNameChanged;
  final Function(String?)? onPriceChanged;

  const ReceiptItemFormRow({
    super.key,
    this.price = '',
    this.itemName = '',
    this.onRemove,
    this.onItemNameChanged,
    this.onPriceChanged,
  });

  @override
  State<ReceiptItemFormRow> createState() => _ReceiptItemFormRowState();
}

class _ReceiptItemFormRowState extends State<ReceiptItemFormRow> {
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item name editing field
          Expanded(child: itemNameField()),
          // Spacer
          SizedBox(width: 5),
          // Price editing field
          Expanded(child: priceField()),
          // Spacer
          SizedBox(width: 5),
          // Remove icon button
          removeIconButton(),
        ],
      ),
    );
  }

  Widget itemNameField() {
    return GenericInputField(
      labelText: '',
      hintText: '',
      iconData: Icons.label,
      validateFunction: validateItemName,
      onSaved: (_) {},
      onChanged: widget.onItemNameChanged,
      initialValue: widget.itemName,
    );
  }

  Widget priceField() {
    return GenericInputField(
      labelText: '',
      hintText: '',
      iconData: Icons.attach_money,
      validateFunction: validatePrice,
      onSaved: (_) {},
      onChanged: widget.onPriceChanged,
      initialValue: widget.price,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: true,
      ),
    );
  }

  Widget removeIconButton() {
    return IconButton(onPressed: widget.onRemove, icon: Icon(Icons.remove));
  }

  String? validateItemName(String? value) {
    final ReceiptItemValidationStatus result =
        ReceiptItemValidator.validateItemName(value ?? '');
    if (result == ReceiptItemValidationStatus.success) {
      return null;
    }

    return null;
  }

  String? validatePrice(String? value) {
    final ReceiptItemValidationStatus status =
        ReceiptItemValidator.validatePrice(value ?? '');
    if (status == ReceiptItemValidationStatus.notANumber) {
      return AppLocalizations.of(
        context,
      )?.newReceiptItemFormValidateAmountNotANumber;
    } else if (status == ReceiptItemValidationStatus.success) {
      return null;
    }

    return null;
  }
}
