import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_docs/blocs/receipt_items_list_cubit.dart';
import 'package:spending_docs/blocs/receipt_items_list_state.dart';
import 'package:spending_docs/database/app_database.dart' show ReceiptItem;
import 'package:spending_docs/widgets/receipt_item_form.dart';
import 'package:spending_docs/widgets/receipt_item_row_widget.dart';

class ReceiptItemsPopup extends StatefulWidget {
  final int receiptId;

  const ReceiptItemsPopup({super.key, required this.receiptId});

  @override
  State<ReceiptItemsPopup> createState() => _ReceiptItemsPopupState();
}

class _ReceiptItemsPopupState extends State<ReceiptItemsPopup> {
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
          _receiptItemsListWidget(context),

          // The form to add a new item
          _receiptItemForm(),
        ],
      ),
    );
  }

  Widget _receiptItemForm() {
    return Expanded(child: ReceiptItemForm(receiptId: widget.receiptId));
  }

  Widget _receiptItemsListWidget(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black54, width: 2.0),
        ),
        child: BlocBuilder<ReceiptItemsListCubit, ReceiptItemsListState>(
          builder: (context, state) {
            if (state is ReceiptItemsListReady) {
              final List<ReceiptItem> items = state.items;
              final List<ReceiptItem> filteredItems = items
                  .where((item) => item.receiptId == widget.receiptId)
                  .toList();
              print('Filtered items: ${filteredItems}');
              return _listWidget(filteredItems);
            }

            if (state is ReceiptItemsListError) {
              final errorMessage = state.error;
              return _showErrorWidget(context, errorMessage);
            }

            return SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _listWidget(List<ReceiptItem> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (_, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ReceiptItemRowWidget(receiptItem: items[index]),
        );
      },
    );
  }

  Widget _showErrorWidget(BuildContext context, String errorMessage) {
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
}
