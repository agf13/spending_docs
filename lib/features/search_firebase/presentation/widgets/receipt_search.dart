import 'dart:async' show Timer;

import 'package:flutter/material.dart';
import 'package:spending_docs/core/database/app_database.dart' show Receipt;
import 'package:spending_docs/dataconnect_generated/generated.dart'
    show ListReceiptsByStoreNameReceipts;
import 'package:spending_docs/features/receipts/data/repositories/receipts_firebase_repository.dart';
import 'package:spending_docs/features/receipts/presentation/widgets/receipt_row.dart';

class ReceiptSearch extends StatefulWidget {
  const ReceiptSearch({super.key});

  @override
  State<ReceiptSearch> createState() => _ReceiptSearchState();
}

class _ReceiptSearchState extends State<ReceiptSearch> {
  final ReceiptsFirebaseRepository _repository = ReceiptsFirebaseRepository();
  final TextEditingController _searchController = TextEditingController();

  late Future<List<ListReceiptsByStoreNameReceipts>> _receipts;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _receipts = fetchReceipts('');
    _searchController.addListener(onValueChanged);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar
        searchBar(),
        // Spacer
        SizedBox(height: 10),
        // Elements
        Expanded(child: receiptList()),
      ],
    );
  }

  Widget searchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
      child: TextFormField(
        controller: _searchController,
        decoration: InputDecoration(
          prefixIcon: prefixIcon(),
          suffixIcon: suffixIcon(),
        ),
      ),
    );
  }

  Widget prefixIcon() {
    return Icon(Icons.search);
  }

  Widget suffixIcon() {
    return IconButton(
      onPressed: () {
        // Reset search
        _searchController.text = '';
      },
      icon: Icon(Icons.close_sharp),
    );
  }

  Widget receiptList() {
    return FutureBuilder<List<ListReceiptsByStoreNameReceipts>>(
      future: _receipts,
      builder: onFutureLoaded,
    );
  }

  Widget onFutureLoaded(
    BuildContext context,
    AsyncSnapshot<List<ListReceiptsByStoreNameReceipts>> snapshot,
  ) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return loadingSpinner();
    }

    if (snapshot.hasError) {
      return showError(snapshot.error.toString());
    }

    final items = snapshot.data ?? [];

    if (items.isEmpty) {
      return showError('No items to show');
    }

    return listItems(items);
  }

  Widget loadingSpinner() {
    return Center(
      child: SizedBox(
        height: 100,
        width: 100,
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget showError(String errorText) {
    return Text(
      errorText,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }

  Widget listItems(List<ListReceiptsByStoreNameReceipts> receipts) {
    return ListView.separated(
      itemCount: receipts.length,
      itemBuilder: (_, index) {
        print('building');
        String date = receipts[index].date.toString();
        print(date);
        Receipt receipt = Receipt(
          id: 0,
          amount: receipts[index].amount,
          storeName: receipts[index].storeName,
          card: receipts[index].card,
          date: DateTime.now(),
        );

        return ReceiptRow(receipt: receipt);
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: 5);
      },
    );
  }

  void onValueChanged() {
    String storeName = _searchController.text.toLowerCase();

    // If the timer is started, cancel it so the request is not made.
    // This is done to account for the new letter being added
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    // Start a timer to make a request
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _receipts = fetchReceipts(storeName);
      });
    });
  }

  Future<List<ListReceiptsByStoreNameReceipts>> fetchReceipts(
    String storeName,
  ) async {
    return await _repository.fetchReceiptsByStoreName(storeName);
  }

  @override
  void dispose() {
    _searchController.removeListener(onValueChanged);
    _searchController.dispose();

    super.dispose();
  }
}
