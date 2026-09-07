import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;
import 'package:spending_docs/core/database/app_database.dart'
    show ReceiptsCompanion, ReceiptItemsCompanion;
import 'package:spending_docs/features/common/presentation/widgets/dateTimePicker.dart';
import 'package:spending_docs/features/common/presentation/widgets/generic_input_field.dart';
import 'package:spending_docs/features/receipt_items/data/repositories/receipt_items_repository.dart'
    show ReceiptItemsRepository;
import 'package:spending_docs/features/receipt_items/domain/receipt_item_validator.dart';
import 'package:spending_docs/features/receipts/blocs/receipt_list_bloc.dart';
import 'package:spending_docs/features/receipts/data/repositories/receipts_repository.dart';
import 'package:spending_docs/features/receipts/domain/validators/receipt_validator.dart';
import 'package:spending_docs/features/scan/data/models/scanned_receipt_dto.dart';
import 'package:spending_docs/features/scan/data/models/scanned_receipt_item_dto.dart';

class ScanReceiptResult extends StatefulWidget {
  final ScannedReceiptDto scannedReceiptDto;

  const ScanReceiptResult({super.key, required this.scannedReceiptDto});

  @override
  State<ScanReceiptResult> createState() => _ScanReceiptResultState();
}

class _ScanReceiptResultState extends State<ScanReceiptResult> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _cardController = TextEditingController();

  final List<TextEditingController> _itemsEditingController = [];

  final _formKey = GlobalKey<FormState>();
  final _animatedListKey = GlobalKey<AnimatedListState>();

  static const int _animationDuration = 200;

  DateTime _dateTime = DateTime.now();

  @override
  void initState() {
    super.initState();

    _amountController.text = widget.scannedReceiptDto.amount.toString();
    _dateController.text = widget.scannedReceiptDto.date
        .toString()
        .split('.')
        .first;
    _storeNameController.text = widget.scannedReceiptDto.storeName ?? '';
    _cardController.text = widget.scannedReceiptDto.card;

    for (
      int index = 0;
      index < widget.scannedReceiptDto.receiptItemList.length;
      index++
    ) {
      final itemNameController = TextEditingController();
      final priceController = TextEditingController();
      _itemsEditingController.addAll([itemNameController, priceController]);
    }
  }

  @override
  Widget build(BuildContext context) {
    //final double heightOfScreen = MediaQuery.of(context).size.height;
    //final double widthOfScreen = MediaQuery.of(context).size.width;
    //final double heightContraint = 1 * heightOfScreen;
    //final double widthConstraint = 1 * widthOfScreen;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Title
              receiptFormTitle(),
              // Spacer
              SizedBox(height: 5),
              // Animated list with receipt details
              receiptDetails(),
              // Action buttons
              actionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget receiptFormTitle() {
    return Text(
      'Review scanned receipt',
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }

  Widget receiptDetails() {
    return Expanded(
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: AnimatedList(
          key: _animatedListKey,
          initialItemCount: widget.scannedReceiptDto.receiptItemList.length + 3,
          itemBuilder: buildAnimatedList,
        ),
      ),
    );
  }

  Widget buildAnimatedList(
    BuildContext context,
    int index,
    Animation animation,
  ) {
    if (index == 0) {
      return mainDetails();
    } else if (index == 1) {
      return Divider(color: Theme.of(context).colorScheme.onPrimaryContainer);
    } else if (index == widget.scannedReceiptDto.receiptItemList.length + 2) {
      return addNewRow();
    }

    return itemAndPriceRowAnimated(index - 2, animation, null);
  }

  Widget mainDetails() {
    return Column(
      children: [amountInput(), storeNameInput(), dateInput(), cardInput()],
    );
  }

  Widget amountInput() {
    return GenericInputField(
      labelText: 'Amount',
      hintText: '',
      iconData: Icons.money,
      validateFunction: ReceiptValidator.validateAmountError,
      extraValueValidation: (_) {
        return checkAmountConsistency();
      },
      onSaved: (_) {},
      controller: _amountController,
    );
  }

  Widget storeNameInput() {
    return GenericInputField(
      labelText: 'Store Name',
      hintText: '',
      iconData: Icons.store,
      validateFunction: ReceiptValidator.validateStoreNameError,
      onSaved: (_) {},
      controller: _storeNameController,
    );
  }

  Widget dateInput() {
    return GenericInputField(
      labelText: 'Date',
      hintText: '',
      iconData: Icons.calendar_today,
      validateFunction: ReceiptValidator.validateDateError,
      onSaved: (_) {},
      controller: _dateController,
      sufixIconButton: dateTimeIconButton(),
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

  Widget cardInput() {
    return GenericInputField(
      labelText: 'Card',
      hintText: '',
      iconData: Icons.card_travel,
      validateFunction: ReceiptValidator.validateDateError,
      onSaved: (_) {},
      controller: _cardController,
    );
  }

  Widget itemAndPriceRowAnimated(
    int index,
    Animation animation,
    ScannedReceiptItemDto? removedItem,
  ) {
    final Tween<Offset> offsetTween = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    );

    return SlideTransition(
      position: animation
          .drive(CurveTween(curve: Curves.easeOut))
          .drive(offsetTween),
      child: itemAndPriceRow(index, removedItem),
    );
  }

  Widget itemAndPriceRow(int index, ScannedReceiptItemDto? removedItem) {
    // Get values
    String itemName = '';
    String price = '';
    if (removedItem != null) {
      itemName = removedItem.itemName;
      price = removedItem.price.toString();
    } else {
      itemName = widget.scannedReceiptDto.receiptItemList[index].itemName;
      price = widget.scannedReceiptDto.receiptItemList[index].price.toString();
    }

    // Create and append controllers
    final itemNameController = _itemsEditingController[index * 2];
    final priceController = _itemsEditingController[index * 2 + 1];

    // Initialize value for controllers
    itemNameController.text = itemName;
    priceController.text = price;

    // Return the widget
    return Column(
      children: [
        // Item and price fields
        Row(
          children: [
            // ItemName
            Flexible(
              flex: 2,
              child: GenericInputField(
                labelText: '',
                hintText: '',
                iconData: Icons.label_rounded,
                validateFunction: ReceiptItemValidator.validateItemNameError,
                onSaved: (_) {},
                controller: itemNameController,
              ),
            ),
            // Spacer
            SizedBox(width: 5),
            // Price
            Flexible(
              flex: 1,
              child: GenericInputField(
                labelText: '',
                hintText: '',
                iconData: Icons.money_off,
                validateFunction: ReceiptItemValidator.validatePriceError,
                onSaved: (_) {},
                controller: priceController,
              ),
            ),
            // Spacer
            SizedBox(width: 5),
            // Delete this row button
            IconButton(
              onPressed: () {
                if (removedItem != null) {
                  return;
                }
                removeItem(index);
              },
              icon: Icon(Icons.remove_sharp),
            ),
          ],
        ),
        // Spacer
        SizedBox(height: 5),
      ],
    );
  }

  void removeItem(int index) {
    // Remove the element from the list
    final removedItem = widget.scannedReceiptDto.receiptItemList.removeAt(
      index,
    );

    // Remove the controllers associated
    _itemsEditingController[index * 2].dispose();
    _itemsEditingController[index * 2 + 1].dispose();
    _itemsEditingController.removeAt(index * 2);
    _itemsEditingController.removeAt(index * 2);

    _animatedListKey.currentState?.removeItem(
      index + 2,
      (context, animation) =>
          itemAndPriceRowAnimated(index, animation, removedItem),
      duration: Duration(milliseconds: _animationDuration),
    );
  }

  Widget addNewRow() {
    return IconButton(onPressed: () => onAddNewRow(), icon: Icon(Icons.add));
  }

  void onAddNewRow() {
    // Add the new ScannedReceiptItemDto
    final int index = widget.scannedReceiptDto.receiptItemList.length;
    final newItemDto = ScannedReceiptItemDto(itemName: '', price: 0);
    widget.scannedReceiptDto.receiptItemList.insert(index, newItemDto);

    // Initialize and append controllers
    final itemNameController = TextEditingController();
    final priceController = TextEditingController();
    itemNameController.text = '';
    priceController.text = '0';
    _itemsEditingController.addAll([itemNameController, priceController]);

    // Add to the the animated list
    _animatedListKey.currentState?.insertItem(
      index + 2, // Accounting for receipt main details and divider
      duration: Duration(milliseconds: _animationDuration),
    );
  }

  Widget actionButtons() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          cancelButton(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [retryButton(), SizedBox(width: 20), saveButton()],
          ),
        ],
      ),
    );
  }

  Widget cancelButton() {
    return TextButton(
      onPressed: () {},
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Cacel',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }

  Widget retryButton() {
    return TextButton(
      onPressed: () {},
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Retry',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
      ),
    );
  }

  Widget saveButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      onPressed: onSave,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          'Save',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
      ),
    );
  }

  void onSave() {
    if (_formKey.currentState!.validate()) {
      final receiptDto = getReceiptDtoFromForm();
      if (receiptDto == null) return;

      saveToRepository(receiptDto);
    }
  }

  ScannedReceiptDto? getReceiptDtoFromForm() {
    final amount = double.tryParse(_amountController.text) ?? 0;
    final storeName = _storeNameController.text;
    final card = _cardController.text;
    final date = _dateTime;
    List<ScannedReceiptItemDto> items = [];

    for (int index = 0; index < _itemsEditingController.length; index += 2) {
      String itemName = _itemsEditingController[index].text;
      double price =
          double.tryParse(_itemsEditingController[index + 1].text) ?? 0;
      items.add(ScannedReceiptItemDto(itemName: itemName, price: price));
    }

    return ScannedReceiptDto(
      amount: amount,
      storeName: storeName,
      date: date,
      card: card,
      receiptItemList: items,
    );
  }

  String? checkAmountConsistency() {
    final receiptDto = getReceiptDtoFromForm();
    if (receiptDto == null) {
      return null; // No amount consistency check can be made if the form is not valid
    }

    double totalAmount = 0;
    for (int index = 0; index < receiptDto.receiptItemList.length; index++) {
      totalAmount += receiptDto.receiptItemList[index].price;
    }

    totalAmount = (totalAmount * 100).round() / 100;
    if (totalAmount == receiptDto.amount) {
      return null;
    } else {
      return 'Total amount missmatch! Actual sum is: $totalAmount';
    }
  }

  /*
    Todo: check transaction errors. If the widgets unmounts before all items are added to the ReceiptItemsRepository,
          data will miss without any obvious signs
  */
  void saveToRepository(ScannedReceiptDto receiptDto) async {
    final ReceiptsCompanion receipt = ReceiptsCompanion(
      amount: Value(receiptDto.amount),
      storeName: Value(receiptDto.storeName),
      date: Value(receiptDto.date),
      card: Value(receiptDto.card),
    );

    int receiptId = await context.read<ReceiptsRepository>().add(receipt);

    for (int index = 0; index < receiptDto.receiptItemList.length; index++) {
      final ReceiptItemsCompanion item = ReceiptItemsCompanion(
        receiptId: Value(receiptId),
        itemName: Value(receiptDto.receiptItemList[index].itemName),
        price: Value(receiptDto.receiptItemList[index].price),
      );

      if (mounted) {
        await context.read<ReceiptItemsRepository>().add(item);
      } else {
        print(
          'Receipt Items related to receipId = $receiptId might not have been all added',
        );
      }
    }

    if (mounted) {
      context.read<ReceiptListBloc>().add(ReceiptRefresh());
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _dateController.dispose();
    _storeNameController.dispose();
    _cardController.dispose();

    for (int index = 0; index < _itemsEditingController.length; index++) {
      _itemsEditingController[index].dispose();
    }

    super.dispose();
  }
}
