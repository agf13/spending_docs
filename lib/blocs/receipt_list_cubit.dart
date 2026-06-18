import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_docs/models/receipt_model.dart';
import 'package:spending_docs/storage/receipt_storage_support_directory.dart';

class ReceiptListCubit extends Cubit<List<ReceiptModel>> {
  final ReceiptStorageSupportDirectory receiptStorage;

  ReceiptListCubit({required this.receiptStorage}) : super([]);

  void loadItems() async {
    final items = await receiptStorage.readAll();
    emit(items);
  }

  void addItem(ReceiptModel receipt) async {
    // Update the storage with the new update
    await receiptStorage.add(receipt);

    // Update the list with the new item
    emit([...state, receipt]);
  }

  void removeItem(ReceiptModel receipt) async {
    // Remove item from storage
    await receiptStorage.delete(receipt);

    // Update the update in list
    state.removeWhere((element) => ReceiptModel.isSame(element, receipt));
    emit(state.toList());
  }
}
