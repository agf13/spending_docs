import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;
import 'package:spending_docs/features/translation/bloc/translation_cubit.dart';

enum LocaleChoice { en, ro }

class SegmentedLocaleSwitch extends StatefulWidget {
  const SegmentedLocaleSwitch({super.key});

  @override
  State<SegmentedLocaleSwitch> createState() => _SegmentedLocaleSwitchState();
}

class _SegmentedLocaleSwitchState extends State<SegmentedLocaleSwitch> {
  LocaleChoice _localeChoice = LocaleChoice.en;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<LocaleChoice>(
      segments: [
        // Locale 'en'
        localeEnSegment(),

        // Locale 'ro'
        localeRoSegment(),
      ],
      selected: <LocaleChoice>{_localeChoice},
      onSelectionChanged: onSelectionChanged,
    );
  }

  ButtonSegment<LocaleChoice> localeEnSegment() {
    return ButtonSegment<LocaleChoice>(
      value: LocaleChoice.en,
      label: Text('EN'),
    );
  }

  ButtonSegment<LocaleChoice> localeRoSegment() {
    return ButtonSegment<LocaleChoice>(
      value: LocaleChoice.ro,
      label: Text('RO'),
    );
  }

  void onSelectionChanged(Set<LocaleChoice> newLocale) {
    // Tell the state which button is selected
    setState(() => _localeChoice = newLocale.first);

    // Change the language of the app
    context.read<TranslationCubit>().setLocale(Locale(newLocale.first.name));
  }
}
