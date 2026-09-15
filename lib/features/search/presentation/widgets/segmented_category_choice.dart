import 'package:flutter/material.dart';
import 'package:spending_docs/features/search/presentation/widgets/search_list_view.dart'
    show SearchCategoryEnum;
import 'package:spending_docs/l10n/app_localizations.dart';

class SegmentedCategoryChoice extends StatefulWidget {
  final void Function(Set<SearchCategoryEnum>) onSelectionChanged;

  const SegmentedCategoryChoice({super.key, required this.onSelectionChanged});

  @override
  State<SegmentedCategoryChoice> createState() =>
      _SegmentedCategoryChoiceState();
}

class _SegmentedCategoryChoiceState extends State<SegmentedCategoryChoice> {
  SearchCategoryEnum _categoryChoice = SearchCategoryEnum.storeName;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<SearchCategoryEnum>(
      segments: [
        storeNameSegment(),
        amountSegment(),
        dateSegment(),
        cardSegment(),
      ],
      selected: <SearchCategoryEnum>{_categoryChoice},
      onSelectionChanged: (value) {
        setState(() => _categoryChoice = value.first);
        widget.onSelectionChanged(value);
      },
      showSelectedIcon: false,
    );
  }

  ButtonSegment<SearchCategoryEnum> storeNameSegment() {
    return ButtonSegment<SearchCategoryEnum>(
      value: SearchCategoryEnum.storeName,
      label: textLabel(AppLocalizations.of(context)!.searchScreenStoreName),
    );
  }

  ButtonSegment<SearchCategoryEnum> amountSegment() {
    return ButtonSegment<SearchCategoryEnum>(
      value: SearchCategoryEnum.amount,
      label: textLabel(AppLocalizations.of(context)!.searchScreenAmount),
    );
  }

  ButtonSegment<SearchCategoryEnum> dateSegment() {
    return ButtonSegment<SearchCategoryEnum>(
      value: SearchCategoryEnum.date,
      label: textLabel(AppLocalizations.of(context)!.searchScreenDate),
    );
  }

  ButtonSegment<SearchCategoryEnum> cardSegment() {
    return ButtonSegment<SearchCategoryEnum>(
      value: SearchCategoryEnum.card,
      label: textLabel(AppLocalizations.of(context)!.searchScreenCard),
    );
  }

  Widget textLabel(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
