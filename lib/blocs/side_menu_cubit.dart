import 'package:flutter_bloc/flutter_bloc.dart';

class SideMenuCubit extends Cubit<int> {
  SideMenuCubit() : super(0);

  void setSubMenuIndex(int index) {
    emit(index);
  }
}
