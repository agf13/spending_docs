import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_docs/core/database/app_database.dart' show Receipt;
import 'package:spending_docs/core/formatters/date_formatter_custom.dart';
import 'package:spending_docs/features/receipts/data/repositories/receipts_repository.dart';
import 'package:spending_docs/features/search/blocs/search_event.dart';
import 'package:spending_docs/features/search/blocs/search_state.dart';
import 'package:spending_docs/features/search/presentation/widgets/search_list_view.dart'
    show SearchCategoryEnum;

class SearchSelectorResponse {
  bool valid;
  String? errorMessage;

  SearchSelectorResponse({required this.valid, this.errorMessage});
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  ReceiptsRepository repository;

  final Map<
    SearchCategoryEnum,
    SearchSelectorResponse Function(Receipt, String)
  >
  selectors = {
    SearchCategoryEnum.storeName: (receipt, searchTerm) {
      searchTerm = searchTerm.toLowerCase();
      String storeName = receipt.storeName?.toLowerCase() ?? '';

      return SearchSelectorResponse(
        valid: (storeName.contains(searchTerm.toLowerCase())),
      );
    },
    SearchCategoryEnum.card: (receipt, searchTerm) {
      String card = receipt.card?.toLowerCase() ?? '';

      return SearchSelectorResponse(
        valid: card.contains(searchTerm.toLowerCase()),
      );
    },
    SearchCategoryEnum.date: (receipt, searchTerm) {
      List<String> dates = searchTerm.split(' ');

      String beforeAsString = DateFormatterCustom.switchDayAndYearNoTime(
        dates.first,
      );
      String afterAsString = DateFormatterCustom.switchDayAndYearNoTime(
        dates.last,
      );

      DateTime? before, after;
      try {
        before = DateTime.parse(beforeAsString);
      } catch (_) {
        before = null;
      }
      try {
        after = DateTime.parse(afterAsString);
      } catch (_) {
        after = null;
      }

      if (before == null && after == null) {
        return SearchSelectorResponse(valid: true);
      } else if (before == null && after != null) {
        return SearchSelectorResponse(valid: after.isAfter(receipt.date));
      } else if (before != null && after == null) {
        return SearchSelectorResponse(valid: before.isBefore(receipt.date));
      } else {
        bool valid =
            (before!.isBefore(receipt.date) && after!.isAfter(receipt.date));
        return SearchSelectorResponse(valid: valid);
      }
    },
    SearchCategoryEnum.amount: (receipt, searchTerm) {
      // If we have a coparision op
      if (searchTerm.length > 1 &&
          (searchTerm[0] == '<' || searchTerm[0] == '>')) {
        // Extracting number without comparison op
        final searchAmountValue = searchTerm.substring(1);
        final amount = double.tryParse(searchAmountValue);

        if (amount == null) return SearchSelectorResponse(valid: true);

        if (searchTerm[0] == '<') {
          return SearchSelectorResponse(valid: receipt.amount < amount);
        } else if (searchTerm[0] == '>') {
          return SearchSelectorResponse(valid: receipt.amount > amount);
        }
      }

      // We don't have a comparision op
      final amount = double.tryParse(searchTerm);
      if (amount == null) return SearchSelectorResponse(valid: true);

      return SearchSelectorResponse(valid: receipt.amount == amount);
    },
  };

  SearchBloc({required this.repository}) : super(SearchStateInitial()) {
    on<SearchEventRequest>(_onRequestData);
  }

  Future<void> _onRequestData(
    SearchEventRequest event,
    Emitter<SearchState> emit,
  ) async {
    try {
      final String searchTerm = event.searchTerm.toLowerCase();
      final searchCategory = event.searchCategory;

      List<Receipt> receipts = await repository.getAll();

      // If no search term provided
      if (searchTerm.isEmpty) {
        emit(SearchStateLoaded(receipts: receipts));
        return;
      }

      // If search term provided
      List<Receipt> filtered = [];
      for (Receipt receipt in receipts) {
        SearchSelectorResponse response = selectors[searchCategory]!(
          receipt,
          searchTerm,
        );

        if (response.valid == true) {
          filtered.add(receipt);
        } else if (response.errorMessage?.isNotEmpty == true) {
          emit(SearchStateError(error: response.errorMessage ?? ''));
          return;
        }
      }

      emit(SearchStateLoaded(receipts: filtered));
    } catch (error) {
      emit(SearchStateError(error: error.toString()));
    }
  }
}
