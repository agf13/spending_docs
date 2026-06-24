import 'package:spending_docs/database/app_database.dart';

abstract class ReceiptsListState {}

class ReceiptsListInitial extends ReceiptsListState {}

class ReceiptsListFetching extends ReceiptsListState {}

class ReceiptsListReady extends ReceiptsListState {
  final List<Receipt> items;
  ReceiptsListReady(this.items);
}

class ReceiptsListError extends ReceiptsListState {
  final String error;
  ReceiptsListError(this.error);
}
