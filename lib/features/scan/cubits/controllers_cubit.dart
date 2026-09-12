import 'package:flutter/material.dart' show TextEditingController;
import 'package:flutter_bloc/flutter_bloc.dart';

class ControllersCubit extends Cubit<List<TextEditingController>> {
  final List<TextEditingController> _controllers = [];

  ControllersCubit() : super([]);

  void initialize() {
    final amountController = TextEditingController();
    final storeNameController = TextEditingController();
    final cardController = TextEditingController();
    final dateController = TextEditingController();

    _controllers.addAll([
      amountController,
      storeNameController,
      cardController,
      dateController,
    ]);

    emit(_controllers);
  }

  TextEditingController getAmountController() {
    return _controllers[0];
  }

  TextEditingController getStoreNameController() {
    return _controllers[1];
  }

  TextEditingController getCardController() {
    return _controllers[2];
  }

  TextEditingController getDateController() {
    return _controllers[3];
  }

  void addControllers(
    TextEditingController itemNameController,
    TextEditingController priceControler,
  ) {
    _controllers.addAll([itemNameController, priceControler]);
    emit(_controllers);
  }

  List<TextEditingController> getPairControllers(int index) {
    return [_controllers[index * 2], _controllers[index * 2 + 1]];
  }
}
