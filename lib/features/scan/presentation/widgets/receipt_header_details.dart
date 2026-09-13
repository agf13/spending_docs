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
  /*
    Calculate the sum of the item list associated with this receipt's headers
  */
  final double? Function() makeTotalItemSum;

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
    required this.makeTotalItemSum,
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
      validateFunction: validateAmount,
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
      validateFunction: validateStoreName,
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
      validateFunction: validateDate,
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
      validateFunction: validateCard,
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

  String? validateAmount(String? value) {
    final ReceiptValidationStatus status = ReceiptValidator.validateAmount(
      value ?? '',
    );

    if (status == ReceiptValidationStatus.notANumber) {
      return AppLocalizations.of(
        context,
      )?.newReceiptFormValidateAmountNotANumber;
    } else if (status == ReceiptValidationStatus.success) {
      // Consistency check
      double? totalItemSum = widget.makeTotalItemSum();

      // If the total sum is null, not all prices are validated so ignore this check
      if (totalItemSum == null) {
        return null;
      }

      // Avoid double quirks
      int coefficient = 1000000;
      totalItemSum = (totalItemSum * coefficient).round() / coefficient;

      // Check equality
      double declaredTotal = double.tryParse(value ?? '') ?? 0;
      if (totalItemSum != declaredTotal) {
        return AppLocalizations.of(
          context,
        )?.scanReceiptResultTotalAmountDifferent(totalItemSum);
      }
    }

    return null;
  }

  String? validateStoreName(String? value) {
    final ReceiptValidationStatus status = ReceiptValidator.validateStoreName(
      value ?? '',
    );

    if (status == ReceiptValidationStatus.success) {
      return null;
    }

    return null;
  }

  String? validateDate(String? value) {
    final ReceiptValidationStatus status = ReceiptValidator.validateDate(
      value ?? '',
    );

    if (status == ReceiptValidationStatus.dateNotChosen) {
      return AppLocalizations.of(
        context,
      )?.newReceiptFormValidateDateDateNotChosen;
    } else if (status == ReceiptValidationStatus.success) {
      return null;
    }

    return null;
  }

  String? validateCard(String? value) {
    final ReceiptValidationStatus status = ReceiptValidator.validateCard(
      value ?? '',
    );

    if (status == ReceiptValidationStatus.invalidCardNumber) {
      return AppLocalizations.of(
        context,
      )?.newReceiptFormValidateCardInvalidCardNumber;
    } else if (status == ReceiptValidationStatus.invalidCardValue) {
      return AppLocalizations.of(
        context,
      )?.newReceiptFormValidateCardInvalidCardValue;
    } else if (status == ReceiptValidationStatus.success) {
      return null;
    }

    return null;
  }
}
