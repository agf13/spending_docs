import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_docs/core/database/app_database.dart';
import 'package:spending_docs/features/receipts/blocs/receipts_list_state.dart';
import 'package:spending_docs/features/receipts/data/repositories/receipts_repository.dart';

class ReceiptsListCubit extends Cubit<ReceiptsListState> {
  final ReceiptsRepository _repository;

  ReceiptsListCubit(this._repository) : super(ReceiptsListInitial());

  Future<void> getItems() async {
    try {
      final items = await _repository.getAll();
      emit(ReceiptsListReady(items));
    } catch (e) {
      emit(ReceiptsListError(e.toString()));
    }
  }

  Future<void> addItem(ReceiptsCompanion receipt) async {
    try {
      await _repository.add(receipt);
      await getItems();
    } catch (e) {
      emit(ReceiptsListError(e.toString()));
    }
  }

  Future<void> removeItem(int id) async {
    try {
      await _repository.remove(id);
      await getItems();
    } catch (e) {
      emit(ReceiptsListError(e.toString()));
    }
  }

  Future<void> editItem(Receipt receipt) async {
    try {
      await _repository.update(receipt);
      await getItems();
    } catch (e) {
      emit(ReceiptsListError(e.toString()));
    }
  }
}
