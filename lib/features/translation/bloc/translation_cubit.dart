import 'package:flutter/material.dart' show Locale;
import 'package:flutter_bloc/flutter_bloc.dart';

class TranslationCubit extends Cubit<Locale> {
  TranslationCubit() : super(const Locale('en'));

  void setLocale(Locale newLocale) {
    emit(newLocale);
  }
}
