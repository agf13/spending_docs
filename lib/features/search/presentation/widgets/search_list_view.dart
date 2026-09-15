import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext, BlocBuilder;
import 'package:spending_docs/core/database/app_database.dart' show Receipt;
import 'package:spending_docs/core/formatters/date_formatter_custom.dart';
import 'package:spending_docs/features/common/presentation/widgets/date_time_icon_button.dart';
import 'package:spending_docs/features/receipts/presentation/widgets/receipt_row.dart';
import 'package:spending_docs/features/search/blocs/search_bloc.dart';
import 'package:spending_docs/features/search/blocs/search_event.dart';
import 'package:spending_docs/features/search/blocs/search_state.dart';
import 'package:spending_docs/features/search/presentation/widgets/segmented_category_choice.dart';
import 'package:spending_docs/l10n/app_localizations.dart';

enum SearchCategoryEnum { storeName, card, date, amount }

class SearchListView extends StatefulWidget {
  const SearchListView({super.key});

  @override
  State<SearchListView> createState() => _SearchListViewState();
}

class _SearchListViewState extends State<SearchListView> {
  SearchCategoryEnum _searchCategory = SearchCategoryEnum.storeName;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _dateBeforeController = TextEditingController();
  final TextEditingController _dateAfterController = TextEditingController();

  @override
  void initState() {
    super.initState();

    initSearchController();

    context.read<SearchBloc>().add(
      SearchEventRequest(searchTerm: '', searchCategory: _searchCategory),
    );
  }

  void initSearchController() {
    _searchController.addListener(onChangedSearchTerm);
    _searchController.text = '';
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
          SizedBox(height: 5),
          // Choose search category
          searchCategory(),
          // Spacer
          SizedBox(height: 10),
          // list of object
          Expanded(child: mainDataView()),
        ],
      ),
    );
  }

  Widget searchBar() {
    if (_searchCategory == SearchCategoryEnum.date) {
      return dateSearchBars();
    } else {
      return textSearchBar();
    }
  }

  Widget dateSearchBars() {
    return Row(
      children: [
        // Before date
        Expanded(
          child: dateSearchBar(
            _dateBeforeController,
            prefixText(AppLocalizations.of(context)!.searchScreenFrom),
            onDateTimeBeforePicked,
          ),
        ),
        // Spacer
        SizedBox(width: 5),
        // After date
        Expanded(
          child: dateSearchBar(
            _dateAfterController,
            prefixText(AppLocalizations.of(context)!.searchScreenTo),
            onDateTimeAfterPicked,
          ),
        ),
      ],
    );
  }

  Widget textSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
      ),
    );
  }

  Widget dateSearchBar(
    TextEditingController controller,
    Widget prefixLabel,
    void Function(String) onPicked,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: prefixLabel,
        suffixIcon: DateTimeIconButton(onPressed: onPicked, onlyPickDate: true),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
      ),
    );
  }

  Widget prefixText(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget searchCategory() {
    return SegmentedCategoryChoice(onSelectionChanged: _onCategoryChanged);
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

    return errorText(AppLocalizations.of(context)!.searchScreenUnknownError);
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

  void onDateTimeBeforePicked(String dateTimeString) {
    dateTimeString = DateFormatterCustom.switchDayAndYearWithTime(
      dateTimeString,
    );
    dateTimeString = DateFormatterCustom.removeHourMinuteSecond(dateTimeString);

    _dateBeforeController.text = dateTimeString;
    String dateInterval = '$dateTimeString ${_dateAfterController.text}';
    updateResults(dateInterval);
  }

  void onDateTimeAfterPicked(String dateTimeString) {
    dateTimeString = DateFormatterCustom.switchDayAndYearWithTime(
      dateTimeString,
    );
    dateTimeString = DateFormatterCustom.removeHourMinuteSecond(dateTimeString);

    _dateAfterController.text = dateTimeString;
    String dateInterval = '${_dateBeforeController.text} $dateTimeString';
    updateResults(dateInterval);
  }

  void onChangedSearchTerm() async {
    String searchTerm = _searchController.text;
    final searchTermLower = searchTerm.toLowerCase();

    updateResults(searchTermLower);
  }

  void _onCategoryChanged(Set<SearchCategoryEnum> searchCategorySet) {
    setState(() {
      _searchCategory = searchCategorySet.first;
    });
    resetSearch();
  }

  void resetSearch() {
    _searchController.text = '';
    updateResults('');
  }

  void updateResults(String searchTerm) async {
    context.read<SearchBloc>().add(
      SearchEventRequest(
        searchTerm: searchTerm,
        searchCategory: _searchCategory,
      ),
    );
  }
}
