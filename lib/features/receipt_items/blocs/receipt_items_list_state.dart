import 'package:equatable/equatable.dart';
import 'package:spending_docs/core/database/app_database.dart';

abstract class ReceiptItemsListState extends Equatable {}

class ReceiptItemsListInitial extends ReceiptItemsListState {
  @override
  List<Object?> get props => [];
}

// class ReceiptItemsListFetching extends ReceiptsListState {}

class ReceiptItemsListReady extends ReceiptItemsListState {
  final List<ReceiptItem> items;
  ReceiptItemsListReady(this.items);

  @override
  List<Object?> get props => items;
}

class ReceiptItemsListError extends ReceiptItemsListState {
  final String error;
  ReceiptItemsListError(this.error);

  @override
  List<Object?> get props => [error];
}
