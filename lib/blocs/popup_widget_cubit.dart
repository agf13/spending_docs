import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_docs/blocs/popup_widget_state.dart';
import 'package:spending_docs/models/popup_menu_enum.dart';

class PopupWidgetCubit extends Cubit<PopupWidgetState> {
  PopupWidgetCubit()
    : super(PopupWidgetActive(activeWindow: PopupMenuEnum.empty));

  /*
    Stores which widget we use in the popup, does not accept extra parameters
  */
  void setPopupWidgetIndex(PopupMenuEnum enumState) {
    emit(PopupWidgetActive(activeWindow: enumState));
  }

  /*
    Signal to show the items of a receipt. Can receive the id of a receipt
  */
  void setPopupWidgetReceiptItems(int receiptId) {
    emit(PopupWidgetReceiptItemActive(receiptId: receiptId));
  }
}
