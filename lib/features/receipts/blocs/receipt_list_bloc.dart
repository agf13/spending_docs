import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_docs/core/database/app_database.dart' show Receipt;
import 'package:spending_docs/features/receipts/data/repositories/receipts_repository.dart';

part 'receipt_event.dart';
part 'receipt_state.dart';

class ReceiptListBloc extends Bloc<ReceiptEvent, ReceiptState> {
  static final pageSize = 20;
  final ReceiptsRepository repository;

  ReceiptListBloc({required this.repository}) : super(ReceiptState()) {
    on<ReceiptFetched>(onNextPage, transformer: droppable());
  }

  Future<void> onNextPage(
    ReceiptFetched event,
    Emitter<ReceiptState> emit,
  ) async {
    if (state.hasReachedMax) return;

    try {
      final offset = state.receiptList.length;
      final newReceipts = await repository.getLimited(offset, pageSize);

      return emit(
        state.copyWith(
          receiptList: List.of(state.receiptList)..addAll(newReceipts),
          status: ReceiptStatus.ready,
          hasReachedMax: newReceipts.length < pageSize,
        ),
      );
    } catch (e) {
      return emit(state.copyWith(status: ReceiptStatus.failure));
    }
  }
}
