import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;
import 'package:spending_docs/core/database/app_database.dart'
    show ReceiptsCompanion, ReceiptItemsCompanion;
import 'package:spending_docs/features/common/presentation/widgets/receipt_item_form_row.dart';
import 'package:spending_docs/features/receipt_items/data/repositories/receipt_items_repository.dart';
import 'package:spending_docs/features/receipts/blocs/receipt_list_bloc.dart';
import 'package:spending_docs/features/receipts/data/repositories/receipts_repository.dart';
import 'package:spending_docs/features/scan/data/models/scanned_receipt_dto.dart';
import 'package:spending_docs/features/scan/data/models/scanned_receipt_item_dto.dart';
import 'package:spending_docs/features/scan/domain/review_receipt_form_state.dart';
import 'package:spending_docs/features/scan/presentation/widgets/receipt_header_details.dart';
import 'package:spending_docs/l10n/app_localizations.dart';

class ReviewScan extends StatefulWidget {
  final ScannedReceiptDto scannedReceiptDto;
  const ReviewScan({super.key, required this.scannedReceiptDto});

  @override
  State<ReviewScan> createState() => _ReviewScanState();
}

class _ReviewScanState extends State<ReviewScan> {
  final _formKey = GlobalKey<FormState>();
  final _animatedKey = GlobalKey<AnimatedListState>();
  final ReviewReceiptFormState _receiptFormState = ReviewReceiptFormState();
  final ScrollController _scrollController = ScrollController();
  late double _itemRowHeight = 0;
  late double _headersHeight = 0;

  /*
    Index 0 has the key for the widget displaying headers and Index 1 for the divider
    All order indexes are corelated to the list of items inside _receiptFormState
  */
  final List<GlobalKey> _listKeys = [];

  @override
  void initState() {
    super.initState();
    initFromDto();
    initListKeys();
  }

  void initFromDto() {
    _receiptFormState.amount = widget.scannedReceiptDto.amount.toString();
    _receiptFormState.storeName = widget.scannedReceiptDto.storeName ?? '';
    _receiptFormState.card = widget.scannedReceiptDto.card;
    _receiptFormState.date = widget.scannedReceiptDto.date
        .toString()
        .split('.')
        .first;

    for (final ScannedReceiptItemDto item
        in widget.scannedReceiptDto.receiptItemList) {
      ReviewReceiptItemState itemState = ReviewReceiptItemState(
        itemName: item.itemName,
        price: item.price.toString(),
      );

      _receiptFormState.items.add(itemState);
    }
  }

  void initListKeys() {
    _listKeys.add(GlobalKey()); // for headers
    _listKeys.add(GlobalKey()); // for divider

    // for all items on a receipt (except headers)
    for (final _ in _receiptFormState.items) {
      _listKeys.add(GlobalKey());
    }
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.75,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Form(key: _formKey, child: formBody()),
        ),
      ),
    );
  }

  Widget formBody() {
    return Column(
      children: [
        // Title
        formTitle(),

        // Spacer
        SizedBox(height: 5),

        // Animated list with receipt details
        Expanded(child: receiptDetails()),

        // Spacer
        SizedBox(height: 5),

        // Actions
        formActions(),
      ],
    );
  }

  Widget formTitle() {
    return Text(
      AppLocalizations.of(context)!.scanReceiptResultFormTitle,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }

  Widget receiptDetails() {
    return AnimatedList(
      key: _animatedKey,
      controller: _scrollController,
      initialItemCount: _receiptFormState.items.length + 3,
      itemBuilder: (context, index, animation) => Padding(
        padding: const EdgeInsets.all(5),
        child: animatedListBuilder(context, index, animation),
      ),
    );
  }

  Widget animatedListBuilder(
    BuildContext context,
    int index,
    Animation animation,
  ) {
    if (index == 0) {
      return ReceiptHeaderDetails(
        key: _listKeys[0],
        initialValueAmount: _receiptFormState.amount,
        initialValueDate: _receiptFormState.date,
        initialValueStoreName: _receiptFormState.storeName,
        initialValueCard: _receiptFormState.card,
        onAmountChanged: (value) => _receiptFormState.amount = value ?? '',
        onStoreNameChanged: (value) =>
            _receiptFormState.storeName = value ?? '',
        onDateChanged: (value) => _receiptFormState.date = value ?? '',
        onCardChanged: (value) => _receiptFormState.card = value ?? '',
        makeTotalItemSum: _receiptFormState.itemPriceSum,
      );
    } else if (index == 1) {
      if (_headersHeight == 0) {
        _getHeaderHeight();
      }

      return Divider(key: _listKeys[1]);
    } else if (index == _receiptFormState.items.length + 2) {
      return addButton();
    } else {
      // Get height of GenericInputFields. We have the first element created
      if (_itemRowHeight == 0 && index > 2) {
        _getItemRowHeight();
      }

      // Continue normal building
      return receiptItemFormRowAnimated(
        _listKeys[index],
        _receiptFormState.items[index - 2],
        animation,
        index,
      );
    }
  }

  Widget receiptItemFormRowAnimated(
    GlobalKey key,
    ReviewReceiptItemState itemState,
    Animation animation,
    int? index,
  ) {
    final Tween<Offset> offsetTween = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    );

    return SlideTransition(
      position: animation
          .drive(CurveTween(curve: Curves.easeOut))
          .drive(offsetTween),
      child: ReceiptItemFormRow(
        key: key,
        price: itemState.price,
        itemName: itemState.itemName,
        onItemNameChanged: (value) {
          if (index == null) return;
          _receiptFormState.items[index - 2].itemName = value ?? '';
        },
        onPriceChanged: (value) {
          if (index == null) return;
          _receiptFormState.items[index - 2].price = value ?? '';
        },
        onRemove: () {
          if (index == null) return;
          onRemoveItem(index);
        },
      ),
    );
  }

  Widget addButton() {
    return IconButton(onPressed: onAddItem, icon: Icon(Icons.add));
  }

  Widget formActions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 0, 10.0, 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Group cancel and a container to nicely allign
          Row(
            children: [
              // Cancel
              cancelButton(),
            ],
          ),
          // Group retry and save buttons toghether
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Retry
              retryButton(),
              // Save
              saveButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget cancelButton() {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Text(
        AppLocalizations.of(context)!.scanReceiptResultButtonCancel,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }

  Widget retryButton() {
    return TextButton(
      onPressed: () {},
      child: Text(
        AppLocalizations.of(context)!.scanReceiptResultButtonRetry,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }

  Widget saveButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      onPressed: () {
        //printReceiptFormState();
        onSave();
      },
      child: Text(
        AppLocalizations.of(context)!.scanReceiptResultButtonSave,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }

  String? checkAmountConsistency() {
    double total = 0;
    double declaredTotal = double.tryParse(_receiptFormState.amount) ?? 0;

    for (int index = 0; index < _receiptFormState.items.length; index++) {
      total += double.tryParse(_receiptFormState.items[index].price) ?? 0;
    }

    total = (total * 1000000).round() / 1000000;
    if (total != declaredTotal) {
      return AppLocalizations.of(
        context,
      )!.scanReceiptResultTotalAmountDifferent(total);
    }

    return null;
  }

  void onAddItem() {
    _receiptFormState.items.add(ReviewReceiptItemState());
    _animatedKey.currentState?.insertItem(
      _receiptFormState.items.length + 1,
      duration: Duration(milliseconds: 200),
    );

    _listKeys.add(GlobalKey());
  }

  void onRemoveItem(int index) {
    ReviewReceiptItemState itemState = _receiptFormState.items.removeAt(
      index - 2, // conversion from AnimtedList index to actual items index
    );
    GlobalKey itemKey = _listKeys.removeAt(index); // No conversion needed

    _animatedKey.currentState?.removeItem(index + 2, (context, animation) {
      return receiptItemFormRowAnimated(itemKey, itemState, animation, null);
    }, duration: Duration(milliseconds: 200));
  }

  void printReceiptFormState() {
    print(_receiptFormState.amount);
    print(_receiptFormState.storeName);
    print(_receiptFormState.date);
    print(_receiptFormState.card);

    for (int index = 0; index < _receiptFormState.items.length; index++) {
      print(
        '${_receiptFormState.items[index].itemName}: ${_receiptFormState.items[index].price}',
      );
    }
  }

  void onSave() async {
    int? index = _ensureFirstErrorItemVisible();
    if (_formKey.currentState?.validate() == true && index == null) {
      await saveToMemory(_receiptFormState);

      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }

  Future<void> saveToMemory(ReviewReceiptFormState formState) async {
    double amount = double.parse(_receiptFormState.amount);
    DateTime date = DateTime.parse(_receiptFormState.date);

    // Save the receipt header details
    ReceiptsCompanion receipt = ReceiptsCompanion(
      amount: Value(amount),
      date: Value(date),
      storeName: Value(_receiptFormState.storeName),
      card: Value(_receiptFormState.card),
    );

    int receiptId = await context.read<ReceiptsRepository>().add(receipt);

    if (!mounted) return;

    // Save the items
    for (int index = 0; index < _receiptFormState.items.length; index++) {
      if (!mounted) return;

      double price = double.parse(_receiptFormState.items[index].price);
      String itemName = _receiptFormState.items[index].itemName;
      ReceiptItemsCompanion item = ReceiptItemsCompanion(
        receiptId: Value(receiptId),
        price: Value(price),
        itemName: Value(itemName),
      );

      context.read<ReceiptItemsRepository>().add(item);
      context.read<ReceiptListBloc>().add(ReceiptRefresh());
    }
  }

  int? _ensureFirstErrorItemVisible() {
    int? index = _receiptFormState.firstInvalid();
    if (index == null) return null;

    double targetOffset = 0;

    if (index >= 0) {
      // Jump to the item with error
      targetOffset = _headersHeight + (index - 1) * _itemRowHeight;
    } else if (index < -2) {
      // Jump to the place in the headers with error
      targetOffset = _headersHeight / 2;
    }

    // Animate aproximately to first error item
    _scrollController
        .animateTo(
          targetOffset,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        )
        .then((_) {
          // Call the validation again to properly show error messages
          _formKey.currentState?.validate();
          return null;
        });

    return index;
  }

  /*
    This is only called on the builder of animated list in order to have at least one item built before this function is called
  */
  void _getHeaderHeight() {
    double? headersHeight =
        (_listKeys[0].currentContext?.findRenderObject() as RenderBox?)
            ?.size
            .height;
    if (headersHeight != null) {
      _headersHeight = headersHeight;
    }
  }

  /*
    This is only called when at least a second item is build from the receipt's item list
  */
  void _getItemRowHeight() {
    double? itemRowHeight =
        (_listKeys[2].currentContext?.findRenderObject() as RenderBox?)
            ?.size
            .height;
    if (itemRowHeight != null) {
      // Account for all items being enclodes in Padding with EdgeInsets.all(5)
      _itemRowHeight = itemRowHeight + 10;
    }
  }
}
