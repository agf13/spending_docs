part of 'receipt_list_bloc.dart';

sealed class ReceiptEvent extends Equatable {
  const ReceiptEvent();

  @override
  List<Object?> get props => [];
}

class ReceiptFetched extends ReceiptEvent {}
