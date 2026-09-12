import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_docs/core/database/app_database.dart'
    show ReceiptItemsCompanion, ReceiptItem;
import 'package:spending_docs/features/receipt_items/blocs/receipt_items_list_state.dart';
import 'package:spending_docs/features/receipt_items/data/repositories/receipt_items_repository.dart';

class ReceiptItemsListCubit extends Cubit<ReceiptItemsListState> {
  final ReceiptItemsRepository _repository;

  ReceiptItemsListCubit(this._repository) : super(ReceiptItemsListInitial());

  Future<void> getItems() async {
    try {
      final items = await _repository.getAll();
      emit(ReceiptItemsListReady(items));
    } catch (e) {
      emit(ReceiptItemsListError(e.toString()));
    }
  }

  Future<void> addItem(ReceiptItemsCompanion receiptItem) async {
    try {
      await _repository.add(receiptItem);
      await getItems();
    } catch (e) {
      emit(ReceiptItemsListError(e.toString()));
    }
  }

  Future<void> removeItem(int id) async {
    try {
      await _repository.remove(id);
      await getItems();
    } catch (e) {
      emit(ReceiptItemsListError(e.toString()));
    }
  }

  Future<void> editItem(ReceiptItem receiptItem) async {
    try {
      await _repository.update(receiptItem);
      await getItems();
    } catch (e) {
      emit(ReceiptItemsListError(e.toString()));
    }
  }
}
