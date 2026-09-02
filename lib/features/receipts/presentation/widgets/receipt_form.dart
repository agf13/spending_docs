import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_docs/core/database/app_database.dart'
    show ReceiptsCompanion, Receipt;
import 'package:spending_docs/features/common/presentation/widgets/dateTimePicker.dart';
import 'package:spending_docs/features/receipts/blocs/receipt_list_bloc.dart';
import 'package:spending_docs/features/receipts/data/repositories/receipts_repository.dart';
import 'package:spending_docs/features/receipts/domain/validators/receipt_validator.dart';
import 'package:spending_docs/l10n/app_localizations.dart';

class ReceiptForm {
  static void showFormPopup({required BuildContext context, Receipt? receipt}) {
    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ReceiptFormBody(receipt: receipt);
      },
    );
  }
}

class ReceiptFormBody extends StatefulWidget {
  final Receipt? receipt;
  const ReceiptFormBody({super.key, this.receipt});

  @override
  State<ReceiptFormBody> createState() => _ReceiptFormBodyState();
}

class _ReceiptFormBodyState extends State<ReceiptFormBody> {
  final double _fieldWidth = 350;
  final double _buttonWidth = 120;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();

  late double _amount;
  late String _storeName;
  late String _card;
  static DateTime _dateTime = DateTime.now();

  int? _receiptId;

  @override
  void initState() {
    super.initState();
    if (widget.receipt != null) {
      _receiptId = widget.receipt!.id;
      _dateController.text = widget.receipt!.date.toString().split('.').first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(key: _formKey, child: formBody());
  }

  Widget formBody() {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Titlu
            formTitle(
              title: _chooseFormTitle(),
              subtitle: _chooseFormSubtitle(),
            ),

            // Form inputs
            inputs(),

            // Spacer
            SizedBox(height: 10),

            // Cancle and Save buttons
            formButtons(),
          ],
        ),
      ),
    );
  }

  String _chooseFormTitle() {
    if (_receiptId == null) {
      return AppLocalizations.of(context)!.newReceiptFromTitle;
    } else {
      return AppLocalizations.of(context)!.editReceiptFormTitle;
    }
  }

  String _chooseFormSubtitle() {
    if (_receiptId == null) {
      return AppLocalizations.of(context)!.newReceiptFormSubtitle;
    } else {
      return AppLocalizations.of(context)!.editReceiptFormSubtitle;
    }
  }

  Widget formTitle({required String title, required String subtitle}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(Icons.receipt_sharp),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  softWrap: true,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  softWrap: true,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget inputs() {
    return Flexible(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // StoreName input
            inputField(
              labelText: AppLocalizations.of(
                context,
              )!.newReceiptFormLabelStoreName,
              hintText: AppLocalizations.of(
                context,
              )!.newReceiptFormHintStoreName,
              iconData: Icons.store,
              validateFunction: ReceiptValidator.validateStoreName,
              onSaved: onStoreNameSaved,
              initialValue: widget.receipt?.storeName,
            ),

            // Amount input
            inputField(
              labelText: AppLocalizations.of(
                context,
              )!.newReceiptFormLabelAmount,
              hintText: AppLocalizations.of(context)!.newReceiptFormHintAmount,
              iconData: Icons.money,
              validateFunction: ReceiptValidator.validateAmount,
              onSaved: onAmountSaved,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              initialValue: widget.receipt?.amount.toString(),
            ),

            // Date input
            inputField(
              labelText: AppLocalizations.of(context)!.newReceiptFormLabelDate,
              hintText: AppLocalizations.of(context)!.newReceiptFormHintDate,
              iconData: Icons.calendar_today,
              validateFunction: ReceiptValidator.validateDate,
              onSaved: onDateSaved,
              sufixIconButton: dateTimeIconButton(),
              controller: _dateController,
              readOnly: true,
            ),

            // Card input
            inputField(
              labelText: AppLocalizations.of(
                context,
              )!.newReceiptFormLabelCardOrCash,
              hintText: AppLocalizations.of(
                context,
              )!.newReceiptFormHintCardOrCash,
              iconData: Icons.card_travel,
              validateFunction: ReceiptValidator.validateCard,
              onSaved: onCardSaved,
              initialValue: widget.receipt?.card,
            ),
          ],
        ),
      ),
    );
  }

  Widget inputField({
    required String labelText,
    required String hintText,
    required IconData iconData,
    required Function(String) validateFunction,
    required Function(String) onSaved,
    TextInputType? keyboardType,
    Widget? sufixIconButton,
    TextEditingController? controller,
    String? initialValue,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label(labelText),
          inputWidget(
            hintText: hintText,
            icon: leftIcon(iconData),
            validateFunction: validateFunction,
            onSaved: onSaved,
            keyboardType: keyboardType,
            sufixIconButton: sufixIconButton,
            controller: controller,
            initialValue: initialValue,
            readOnly: readOnly,
          ),
        ],
      ),
    );
  }

  Widget leftIcon(IconData iconData) {
    return Icon(
      iconData,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }

  Widget label(String text) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Text(
      text,
      style: textTheme.titleSmall?.copyWith(color: colorScheme.onSurface),
    );
  }

  Widget inputWidget({
    required String hintText,
    required Widget icon,
    required Function(String) validateFunction,
    required Function(String) onSaved,
    TextInputType? keyboardType,
    Widget? sufixIconButton,
    TextEditingController? controller,
    String? initialValue,
    bool readOnly = false,
  }) {
    return SizedBox(
      width: _fieldWidth,
      child: TextFormField(
        readOnly: readOnly,
        initialValue: initialValue,
        keyboardType: keyboardType,
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceContainerLow,
          prefixIcon: icon,
          suffixIcon: sufixIconButton,
          errorMaxLines: 5,
        ),
        validator: (value) => validateField(
          validateFunction: validateFunction,
          value: value ?? '',
        ),
        onSaved: (value) => onSaved(value ?? ''),
      ),
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
      _dateTime = pickedDateTime;
      _dateController.text = _dateTime.toString().split('.')[0];
    }
  }

  /*
    Def: Handle validation in one place for different ReceiptValidationStatus cases.
  */
  String? validateField({
    required Function(String) validateFunction,
    required String value,
  }) {
    final result = validateFunction(value);
    if (result == ReceiptValidationStatus.success) return null;

    switch (result) {
      case ReceiptValidationStatus.success:
        return null;

      case ReceiptValidationStatus.notANumber:
        return AppLocalizations.of(
          context,
        )?.newReceiptFormValidateAmountNotANumber;

      case ReceiptValidationStatus.invalidCardValue:
        return AppLocalizations.of(
          context,
        )?.newReceiptFormValidateCardInvalidCardValue;

      case ReceiptValidationStatus.invalidCardNumber:
        return AppLocalizations.of(
          context,
        )?.newReceiptFormValidateCardInvalidCardNumber;

      case ReceiptValidationStatus.dateNotChosen:
        return AppLocalizations.of(
          context,
        )?.newReceiptFormValidateDateDateNotChosen;

      default:
        return AppLocalizations.of(
          context,
        )?.newReceiptFromValidateUnexpectedCase;
    }
  }

  void onStoreNameSaved(String storeName) {
    _storeName = storeName;
  }

  void onAmountSaved(String amount) {
    _amount = double.tryParse(amount) ?? 0;
  }

  void onCardSaved(String card) {
    _card = card;
  }

  void onDateSaved(String date) {
    // date is saved through a controller
    return;
  }

  Widget formButtons() {
    return SizedBox(
      width: _fieldWidth,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            // Cancel button
            formButton(
              label: AppLocalizations.of(context)!.newReceiptFormCancel,
              onPressed: () => onCancel(),
            ),

            // Save button
            formButton(
              label: AppLocalizations.of(context)!.newReceiptFormSave,
              onPressed: () => onSave(),
            ),
          ],
        ),
      ),
    );
  }

  void onCancel() {
    Navigator.of(context).pop();
  }

  void onSave() {
    if (_formKey.currentState!.validate()) {
      // Save all fields to be usable
      _formKey.currentState!.save();

      // Check if we are editing or adding a new receipt
      if (_receiptId != null) {
        updateReceipt(_receiptId!, _storeName, _amount, _dateTime, _card);
      } else {
        addReceipt(_storeName, _amount, _dateTime, _card);
      }
      Navigator.of(context).pop();
    } else {
      return;
    }
  }

  Future<void> addReceipt(
    String storeName,
    double amount,
    DateTime date,
    String card,
  ) async {
    final receiptCompanion = ReceiptsCompanion(
      storeName: Value(storeName),
      amount: Value(amount),
      date: Value(date),
      card: Value(card),
    );

    print('---- add called');
    context.read<ReceiptsRepository>().add(receiptCompanion);
    context.read<ReceiptListBloc>().add(ReceiptRefresh());
  }

  Future<void> updateReceipt(
    int receiptId,
    String storeName,
    double amount,
    DateTime date,
    String card,
  ) async {
    Receipt updatedReceipt = Receipt(
      id: receiptId,
      storeName: storeName,
      amount: amount,
      date: date,
      card: card,
    );

    print('---- update called');
    context.read<ReceiptsRepository>().update(updatedReceipt);
    context.read<ReceiptListBloc>().add(ReceiptRefresh());
  }

  Widget formButton({required String label, required Function() onPressed}) {
    return SizedBox(
      width: _buttonWidth,
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
}
