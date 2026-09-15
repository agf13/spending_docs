import 'package:equatable/equatable.dart';
import 'package:spending_docs/core/database/app_database.dart' show Receipt;

class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchStateInitial extends SearchState {}

class SearchStateLoading extends SearchState {}

class SearchStateLoaded extends SearchState {
  final List<Receipt> receipts;

  const SearchStateLoaded({required this.receipts});

  @override
  List<Object?> get props => [receipts];
}

class SearchStateError extends SearchState {
  final String error;

  const SearchStateError({required this.error});

  @override
  List<Object?> get props => [error];
}
