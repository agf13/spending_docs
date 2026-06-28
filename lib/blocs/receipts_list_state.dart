import 'package:equatable/equatable.dart';
import 'package:spending_docs/database/app_database.dart';

abstract class ReceiptsListState extends Equatable {}

class ReceiptsListInitial extends ReceiptsListState {
  @override
  List<Object?> get props => [];
}

// class ReceiptsListFetching extends ReceiptsListState {}

class ReceiptsListReady extends ReceiptsListState {
  final List<Receipt> items;
  ReceiptsListReady(this.items);

  @override
  List<Object?> get props => items;
}

class ReceiptsListError extends ReceiptsListState {
  final String error;
  ReceiptsListError(this.error);

  @override
  List<Object?> get props => [error];
}
