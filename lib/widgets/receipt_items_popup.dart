import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_docs/blocs/popup_widget_cubit.dart';
import 'package:spending_docs/blocs/receipt_items_list_cubit.dart';
import 'package:spending_docs/blocs/receipt_items_list_state.dart';
import 'package:spending_docs/core/utils/receipt_conversions.dart';
import 'package:spending_docs/database/app_database.dart'
    show ReceiptItem, ReceiptItemsCompanion;
import 'package:spending_docs/models/popup_menu_enum.dart';
import 'package:spending_docs/widgets/item_text_input.dart';
import 'package:spending_docs/widgets/receipt_item_row_widget.dart';

class ReceiptItemsPopup extends StatefulWidget {
  final int receiptId;

  const ReceiptItemsPopup({super.key, required this.receiptId});

  @override
  State<ReceiptItemsPopup> createState() => _ReceiptItemsPopupState();
}

class _ReceiptItemsPopupState extends State<ReceiptItemsPopup> {
  final _formKey = GlobalKey<FormState>();

  final _itemNameTextController = TextEditingController();
  final _priceTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // The list of items from a receipt
          receiptItemsListWidget(context),

          // The form to add a new item
          receiptItemForm(context),
        ],
      ),
    );
  }

  Widget receiptItemsListWidget(BuildContext context) {
    return BlocBuilder<ReceiptItemsListCubit, ReceiptItemsListState>(
      builder: (context, state) {
        if (state is ReceiptItemsListReady) {
          final items = state.items;
          return listWidget(items);
        }

        if (state is ReceiptItemsListError) {
          final errorMessage = state.error;
          return showErrorWidget(context, errorMessage);
        }

        return SizedBox.shrink();
      },
    );
  }

  Widget listWidget(List<ReceiptItem> items) {
    return Expanded(
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ReceiptItemRowWidget(receiptItem: items[index]),
          );
        },
      ),
    );
  }

  Widget showErrorWidget(BuildContext context, String errorMessage) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text of error
          Text(errorMessage),

          // SomeSpace
          SizedBox(height: 10),

          // Refresh button
          ElevatedButton(
            onPressed: () => context.read<ReceiptItemsListCubit>().getItems(),
            child: Text('Refresh list'),
          ),
        ],
      ),
    );
  }

  Widget receiptItemForm(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Input fields
              Row(
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
              ),

              // Buttons
              formButtons(context),
            ],
          ),
        ),
      ),
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
        IconButton(
          onPressed: () {
            context.read<PopupWidgetCubit>().setPopupWidgetIndex(
              PopupMenuEnum.empty,
            );
          },
          icon: Icon(Icons.close),
        ),

        // Submit button
        IconButton(
          onPressed: () {
            submitForm(context);
          },
          icon: Icon(Icons.check),
        ),
      ],
    );
  }

  void submitForm(BuildContext context) {
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
}
