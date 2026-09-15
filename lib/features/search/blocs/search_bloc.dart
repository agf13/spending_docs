import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_docs/core/database/app_database.dart' show Receipt;
import 'package:spending_docs/features/receipts/data/repositories/receipts_repository.dart';
import 'package:spending_docs/features/search/blocs/search_event.dart';
import 'package:spending_docs/features/search/blocs/search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  ReceiptsRepository repository;

  SearchBloc({required this.repository}) : super(SearchStateInitial()) {
    on<SearchEventRequest>(_onRequestData);
  }

  Future<void> _onRequestData(
    SearchEventRequest event,
    Emitter<SearchState> emit,
  ) async {
    try {
      final String searchTerm = event.searchTerm.toLowerCase();

      List<Receipt> receipts = await repository.getAll();
      List<Receipt> filtered = receipts.where((receipt) {
        String storeName = receipt.storeName ?? '';
        storeName = storeName.toLowerCase();
        return storeName.contains(searchTerm);
      }).toList();

      emit(SearchStateLoaded(receipts: filtered));
    } catch (error) {
      emit(SearchStateError(error: error.toString()));
    }
  }
}
