import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext, BlocBuilder;
import 'package:spending_docs/core/database/app_database.dart' show Receipt;
import 'package:spending_docs/features/receipts/presentation/widgets/receipt_row.dart';
import 'package:spending_docs/features/search/blocs/search_bloc.dart';
import 'package:spending_docs/features/search/blocs/search_event.dart';
import 'package:spending_docs/features/search/blocs/search_state.dart';

class SearchListView extends StatefulWidget {
  const SearchListView({super.key});

  @override
  State<SearchListView> createState() => _SearchListViewState();
}

class _SearchListViewState extends State<SearchListView> {
  @override
  void initState() {
    super.initState();
    context.read<SearchBloc>().add(SearchEventRequest(searchTerm: ''));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          // Search bar
          searchBar(),
          // Spacer
          SizedBox(height: 10),
          // list of object
          Expanded(child: mainDataView()),
        ],
      ),
    );
  }

  Widget searchBar() {
    return Row(
      children: [
        // Label
        Text(
          'Search:',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        // Spacer
        SizedBox(width: 5),
        // Search field
        Expanded(child: TextField(onChanged: onChangedSearchTerm)),
      ],
    );
  }

  Widget mainDataView() {
    return BlocBuilder<SearchBloc, SearchState>(builder: searchBlocBuilder);
  }

  Widget searchBlocBuilder(BuildContext context, SearchState state) {
    if (state is SearchStateInitial) {
      return loadingSpinner();
    } else if (state is SearchStateError) {
      return errorText(state.error);
    } else if (state is SearchStateLoaded) {
      return filteredList(state.receipts);
    }

    return errorText('Unknown error. Try to reopen the app');
  }

  Widget loadingSpinner() {
    return Center(
      child: SizedBox(
        height: 50,
        width: 50,
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget errorText(String error) {
    return Center(
      child: Text(
        error,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }

  Widget filteredList(List<Receipt> receipts) {
    return ListView.separated(
      itemCount: receipts.length,
      itemBuilder: (_, index) => filteredListBuilder(receipts[index]),
      separatorBuilder: (_, _) => SizedBox(height: 5),
    );
  }

  Widget filteredListBuilder(Receipt receipt) {
    return ReceiptRow(receipt: receipt);
  }

  void onChangedSearchTerm(String? searchTerm) async {
    final searchTermLower = searchTerm?.toLowerCase() ?? '';
    context.read<SearchBloc>().add(
      SearchEventRequest(searchTerm: searchTermLower),
    );
  }
}
