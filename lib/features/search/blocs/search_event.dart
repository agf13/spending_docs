import 'package:equatable/equatable.dart';
import 'package:spending_docs/features/search/presentation/widgets/search_list_view.dart'
    show SearchCategoryEnum;

class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchEventRequest extends SearchEvent {
  final String searchTerm;
  final SearchCategoryEnum searchCategory;

  const SearchEventRequest({
    required this.searchTerm,
    required this.searchCategory,
  });

  @override
  List<Object?> get props => [searchTerm];
}
