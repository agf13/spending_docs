part of 'receipt_list_bloc.dart';

enum ReceiptStatus { initial, ready, failure }

class ReceiptState extends Equatable {
  final ReceiptStatus status;
  final List<Receipt> receiptList;
  final bool hasReachedMax;

  const ReceiptState({
    this.status = ReceiptStatus.initial,
    this.receiptList = const <Receipt>[],
    this.hasReachedMax = false,
  });

  ReceiptState copyWith({
    ReceiptStatus? status,
    List<Receipt>? receiptList,
    bool? hasReachedMax,
  }) {
    return ReceiptState(
      status: status ?? this.status,
      receiptList: receiptList ?? this.receiptList,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [status, receiptList, hasReachedMax];
}
