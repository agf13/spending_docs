import 'package:spending_docs/models/popup_menu_enum.dart';

abstract class PopupWidgetState {}

class PopupWidgetActive extends PopupWidgetState {
  final PopupMenuEnum activeWindow;

  PopupWidgetActive({required this.activeWindow});
}

class PopupWidgetReceiptItemActive extends PopupWidgetState {
  final int receiptId;

  PopupWidgetReceiptItemActive({required this.receiptId});
}
