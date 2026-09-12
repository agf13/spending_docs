import 'package:flutter_bloc/flutter_bloc.dart';

class TimePickerCubit extends Cubit<Duration?> {
  TimePickerCubit() : super(Duration.zero);

  Future<void> setDuration(Duration? newDuration) async {
    emit(newDuration);
  }
}
