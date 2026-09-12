import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_docs/features/receipts/blocs/receipt_list_bloc.dart';
import 'package:spending_docs/features/receipts/presentation/widgets/receipt_row.dart';
import 'package:spending_docs/l10n/app_localizations.dart';

class ReceiptListView extends StatefulWidget {
  @override
  State<ReceiptListView> createState() => _ReceiptListViewState();
}

class _ReceiptListViewState extends State<ReceiptListView> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReceiptListBloc, ReceiptState>(
      builder: handleBlocBuilder,
    );
  }

  Widget handleBlocBuilder(BuildContext context, ReceiptState state) {
    // If initial state, show loading spinner
    if (state.status == ReceiptStatus.initial) {
      return Center(child: loadingSpinner());
    }

    // If error, inform the user there was an error
    if (state.status == ReceiptStatus.failure) {
      return errorText(context);
    }

    // If ready, display list
    final itemCount = state.hasReachedMax
        ? state.receiptList.length
        : state.receiptList.length + 1;

    return ListView.builder(
      controller: scrollController,
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return handleListBuilder(context, index, state);
      },
    );
  }

  Widget loadingSpinner() {
    return CircularProgressIndicator();
  }

  Widget errorText(BuildContext context) {
    return Text(AppLocalizations.of(context)!.homeDataFetchError);
  }

  Widget handleListBuilder(
    BuildContext context,
    int index,
    ReceiptState state,
  ) {
    if (index >= state.receiptList.length) {
      return loadingSpinner();
    }

    return ReceiptRow(receipt: state.receiptList[index]);
  }

  Widget lastElementInList() {
    return Column(children: [loadingSpinner(), SizedBox(height: 100)]);
  }

  void onScroll() {
    if (isBottom) {
      context.read<ReceiptListBloc>().add(ReceiptFetched());
    }
  }

  bool get isBottom {
    if (!scrollController.hasClients) return false;
    final maxScroll = scrollController.position.maxScrollExtent;
    final currentScroll = scrollController.offset;

    // If the user has 200 more pixels untill the end of the list
    return currentScroll >= (maxScroll - 200);
  }
}
