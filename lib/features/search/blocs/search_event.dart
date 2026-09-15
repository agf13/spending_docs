import 'package:equatable/equatable.dart';

class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchEventRequest extends SearchEvent {
  final String searchTerm;

  const SearchEventRequest({required this.searchTerm});

  @override
  List<Object?> get props => [searchTerm];
}
