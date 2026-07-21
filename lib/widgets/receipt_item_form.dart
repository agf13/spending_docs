import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;
import 'package:spending_docs/blocs/popup_widget_cubit.dart';
import 'package:spending_docs/blocs/receipt_items_list_cubit.dart';
import 'package:spending_docs/core/utils/receipt_conversions.dart';
import 'package:spending_docs/database/app_database.dart';
import 'package:spending_docs/models/popup_menu_enum.dart';
import 'package:spending_docs/widgets/item_text_input.dart';

class ReceiptItemForm extends StatefulWidget {
  final int receiptId;
  final int? id;
  final String? itemName;
  final double? price;

  const ReceiptItemForm({
    super.key,
    required this.receiptId,
    this.id,
    this.itemName,
    this.price,
  });

  @override
  State<ReceiptItemForm> createState() => _ReceiptItemFormState();
}

class _ReceiptItemFormState extends State<ReceiptItemForm> {
  final _formKey = GlobalKey<FormState>();

  final _itemNameTextController = TextEditingController();
  final _priceTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Init form fields
    _itemNameTextController.text = widget.itemName ?? '';
    if (widget.price != null) {
      _priceTextController.text = widget.price!.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return receiptItemForm(context);
  }

  Widget receiptItemForm(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Input fields
            formFields(context),

            // Spacer
            SizedBox(height: 10),

            // Buttons
            formButtons(context),
          ],
        ),
      ),
    );
  }

  Widget formFields(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Insert name of item
        Expanded(
          child: ItemTextInput(
            labelText: 'Item Name',
            hintText: 'cereals',
            textController: _itemNameTextController,
            prefixIcon: Icon(Icons.label),
            keyboardType: TextInputType.text,
            validationFunction: validateItemName,
          ),
        ),

        // Spacer
        SizedBox(width: 10),

        // Insert price of item
        Expanded(
          child: ItemTextInput(
            labelText: 'Price',
            hintText: '123.99',
            textController: _priceTextController,
            prefixIcon: Icon(Icons.money),
            keyboardType: TextInputType.text,
            validationFunction: validatePrice,
          ),
        ),
      ],
    );
  }

  String? validateItemName(String? text) {
    if (text == null || text.isEmpty) {
      return 'Item name cannot be empty';
    }
    return null;
  }

  String? validatePrice(String? text) {
    if (ReceiptConversions.textToDouble(text ?? '') == null) {
      return 'Price should be a number';
    }

    return null;
  }

  Widget formButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Close button
        _closeButton(context),

        // Spacer
        SizedBox(width: 10),

        // Submit button
        _submitButton(context),
      ],
    );
  }

  Widget _closeButton(BuildContext context) {
    if (widget.id == null) {
      return IconButton(
        onPressed: () {
          context.read<PopupWidgetCubit>().setPopupWidgetIndex(
            PopupMenuEnum.empty,
          );
        },
        icon: Icon(Icons.close),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _submitButton(BuildContext context) {
    if (widget.id == null) {
      return IconButton(
        onPressed: () {
          _submitForm(context);
        },
        icon: Icon(Icons.check),
      );
    } else {
      return ElevatedButton(
        onPressed: () {
          _submitForm(context);
        },
        child: Text('Save'),
      );
    }
  }

  void _submitForm(BuildContext context) {
    if (widget.id == null) {
      _addItem(context);
      _resetFormValues();
    } else {
      _editItem(context);
    }
  }

  void _addItem(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final itemName = _itemNameTextController.text;
      final priceText = _priceTextController.text;

      final price = ReceiptConversions.textToDouble(priceText);

      if (price == null || itemName.isEmpty) return;

      ReceiptItemsCompanion item = ReceiptItemsCompanion(
        itemName: Value(itemName),
        price: Value(price),
        receiptId: Value(widget.receiptId),
      );

      context.read<ReceiptItemsListCubit>().addItem(item);
    }
  }

  void _editItem(BuildContext context) {
    final itemName = _itemNameTextController.text;
    final priceText = _priceTextController.text;

    final price = ReceiptConversions.textToDouble(priceText);

    if (price == null || itemName.isEmpty) return;

    ReceiptItem item = ReceiptItem(
      id: widget.id!,
      itemName: itemName,
      price: price,
      receiptId: widget.receiptId,
    );

    context.read<ReceiptItemsListCubit>().editItem(item);
  }

  void _resetFormValues() {
    _formKey.currentState?.reset();
  }
}
