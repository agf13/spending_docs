import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spending_docs/blocs/popup_widget_cubit.dart';
import 'package:spending_docs/blocs/popup_widget_state.dart';
import 'package:spending_docs/blocs/receipts_list_cubit.dart';
import 'package:spending_docs/blocs/receipts_list_state.dart';
import 'package:spending_docs/models/popup_menu_enum.dart';
import 'package:spending_docs/widgets/receipt_filter_form.dart';
import 'package:spending_docs/widgets/receipt_form.dart';
import 'package:spending_docs/widgets/receipt_items_popup.dart';
import 'package:spending_docs/widgets/receipt_row_widget.dart';
import 'package:spending_docs/widgets/sidebar_widget.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() {
    return _HomepageScreenState();
  }
}

class _HomepageScreenState extends State<HomepageScreen> {
  final _screenWidthFactor = 0.8;
  final _screenHeightFactor = 0.6;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My documenting app")),
      body: Stack(
        children: [
          // HomePage screen
          sideBarAndTable(context),

          // Display the receipt form only if needed
          popupWidget(context),
        ],
      ),
    );
  }

  Widget sideBarAndTable(BuildContext context) {
    return Row(
      children: [
        // Side menu
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SidebarWidget(),
          ),
        ),

        // List with items
        Expanded(
          flex: 5,
          child: BlocBuilder<ReceiptsListCubit, ReceiptsListState>(
            builder: (context, state) {
              // Display the list of items
              if (state is ReceiptsListReady) {
                final itemList = state.items;

                return ListView.builder(
                  itemCount: itemList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ReceiptRowWidget(receipt: itemList[index]),
                    );
                  },
                );
              }

              // Display the text of the error
              if (state is ReceiptsListError) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      // Error message
                      Text(state.error),
                      // Spacer
                      SizedBox(height: 10),
                      // Refresh Button
                      ElevatedButton(
                        onPressed: () =>
                            context.read<ReceiptsListCubit>().getItems(),
                        child: Text('Refresh'),
                      ),
                    ],
                  ),
                );
              }

              // Return empty spacer
              return SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget sideMenuOpenedWidget(
    BuildContext context,
    PopupWidgetState popupWidgetState,
  ) {
    if (popupWidgetState is PopupWidgetActive) {
      // handle simple popup
      return switch (popupWidgetState.activeWindow) {
        PopupMenuEnum.empty => Container(), // Just empty widget
        PopupMenuEnum.addReceipt => ReceiptForm(
          onClose: () {
            closePopupWidgetDisplayed(context);
          },
        ), // The add receipt form
        PopupMenuEnum.filterReceipt => ReceiptFilterForm(
          onClose: () {
            closePopupWidgetDisplayed(context);
          },
        ), // Set filter form
      };
    } else if (popupWidgetState is PopupWidgetReceiptItemActive) {
      // handle popup with receipt id
      return ReceiptItemsPopup(receiptId: popupWidgetState.receiptId);
    }

    // Default case as an empty widget
    return SizedBox.shrink();
  }

  Widget popupWidget(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final popupWidgetState = context.watch<PopupWidgetCubit>().state;

    if (popupWidgetState is PopupWidgetActive &&
        popupWidgetState.activeWindow == PopupMenuEnum.empty) {
      return SizedBox.shrink();
    }

    return Stack(
      children: [
        // Gesture detector to close the form
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            closePopupWidgetDisplayed(context);
          },
        ),

        // Widget opened from side menu
        Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: screenWidth * _screenWidthFactor,
              maxHeight: screenHeight * _screenHeightFactor,
            ),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: Colors.amber,
              child: sideMenuOpenedWidget(context, popupWidgetState),
            ),
          ),
        ),
      ],
    );
  }

  void closePopupWidgetDisplayed(BuildContext context) {
    context.read<PopupWidgetCubit>().setPopupWidgetIndex(PopupMenuEnum.empty);
  }
}
