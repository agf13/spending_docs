import 'package:flutter/material.dart';

class NewReceiptForm {
  static void showFormPopup(BuildContext context) {
    final GlobalKey<FormState> key = GlobalKey<FormState>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Form(key: key, child: formBody(context));
      },
    );
  }

  static Widget formBody(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // StoreName input
          inputField(
            context: context,
            labelText: 'StoreName',
            textHint: 'Supermarket BuyOnSale',
            iconData: Icons.store,
          ),
          // StoreName input
          inputField(
            context: context,
            labelText: 'Amount',
            textHint: '123.01',
            iconData: Icons.money,
          ),
          // StoreName input
          inputField(
            context: context,
            labelText: 'Date',
            textHint: '...',
            iconData: Icons.calendar_month,
          ),
          // StoreName input
          inputField(
            context: context,
            labelText: 'Card or cash',
            textHint: '1234 or cash',
            iconData: Icons.card_travel,
          ),
        ],
      ),
    );
  }

  static Widget inputField({
    required BuildContext context,
    required String labelText,
    required String textHint,
    required IconData iconData,
  }) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label(context, labelText),
          inputWidget(context, textHint, leftIcon(context, iconData)),
        ],
      ),
    );
  }

  static Widget leftIcon(BuildContext context, IconData iconData) {
    return Icon(
      iconData,
      color: Theme.of(context).colorScheme.onSurfaceVariant,
    );
  }

  static Widget label(BuildContext context, String text) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Text(
      text,
      style: textTheme.titleSmall?.copyWith(color: colorScheme.onSurface),
    );
  }

  static Widget inputWidget(
    BuildContext context,
    String labelText,
    Widget icon,
  ) {
    return SizedBox(
      width: 250,
      child: TextFormField(
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceContainerLow,
          prefixIcon: icon,
        ),
      ),
    );
  }
}
