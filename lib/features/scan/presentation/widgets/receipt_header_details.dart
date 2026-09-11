import 'package:flutter/material.dart';
import 'package:spending_docs/features/common/presentation/widgets/dateTimePicker.dart';
import 'package:spending_docs/features/common/presentation/widgets/generic_input_field.dart';
import 'package:spending_docs/features/receipts/domain/validators/receipt_validator.dart';
import 'package:spending_docs/l10n/app_localizations.dart';

class ReceiptHeaderDetails extends StatefulWidget {
  final String initialValueAmount;
  final String initialValueDate;
  final String initialValueStoreName;
  final String initialValueCard;

  final Function(String?) onAmountChanged;
  final Function(String?) onStoreNameChanged;
  final Function(String?) onDateChanged;
  final Function(String?) onCardChanged;
  final VoidCallback extraCheck;

  const ReceiptHeaderDetails({
    super.key,
    required this.initialValueAmount,
    required this.initialValueDate,
    required this.initialValueStoreName,
    required this.initialValueCard,
    required this.onAmountChanged,
    required this.onStoreNameChanged,
    required this.onDateChanged,
    required this.onCardChanged,
    required this.extraCheck,
  });

  @override
  State<ReceiptHeaderDetails> createState() => _ReceiptHeaderDetailsState();
}

class _ReceiptHeaderDetailsState extends State<ReceiptHeaderDetails> {
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _dateController.text = widget.initialValueDate;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Amount
        amountFormField(),
        // Store name
        storeNameFormField(),
        // Date
        dateFormField(),
        // Card
        cardFormField(),
      ],
    );
  }

  Widget amountFormField() {
    return GenericInputField(
      labelText: AppLocalizations.of(context)!.scanReceiptResultFormLabelAmout,
      hintText: '',
      iconData: Icons.money,
      validateFunction: ReceiptValidator.validateAmountError,
      extraValueValidation: (_) => widget.extraCheck(),
      onSaved: (_) {},
      onChanged: widget.onAmountChanged,
      initialValue: widget.initialValueAmount,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: true,
      ),
    );
  }

  Widget storeNameFormField() {
    return GenericInputField(
      labelText: AppLocalizations.of(
        context,
      )!.scanReceiptResultFormLabelStoreName,
      hintText: '',
      iconData: Icons.store,
      validateFunction: ReceiptValidator.validateStoreNameError,
      onSaved: (_) {},
      onChanged: widget.onStoreNameChanged,
      initialValue: widget.initialValueStoreName,
    );
  }

  Widget dateFormField() {
    return GenericInputField(
      readOnly: true,
      labelText: AppLocalizations.of(context)!.scanReceiptResultFormLabelDate,
      hintText: '',
      iconData: Icons.calendar_month,
      validateFunction: ReceiptValidator.validateDateError,
      onSaved: (_) {},
      onChanged: widget.onDateChanged,
      sufixIconButton: dateTimeIconButton(),
      controller: _dateController,
    );
  }

  Widget cardFormField() {
    return GenericInputField(
      labelText: AppLocalizations.of(context)!.scanReceiptResultFormLabelCard,
      hintText: '',
      iconData: Icons.card_travel,
      validateFunction: ReceiptValidator.validateCardError,
      onSaved: (_) {},
      onChanged: widget.onCardChanged,
      initialValue: widget.initialValueCard,
    );
  }

  Widget dateTimeIconButton() {
    return IconButton(
      onPressed: handlePickedDateTime,
      icon: Icon(Icons.calendar_today),
    );
  }

  Future<void> handlePickedDateTime() async {
    final pickedDateTime = await pickDateTime(context);

    if (pickedDateTime != null) {
      final dateAsString = pickedDateTime.toString().split('.')[0];
      widget.onDateChanged(dateAsString);
      _dateController.text = dateAsString;
    }
  }
}
