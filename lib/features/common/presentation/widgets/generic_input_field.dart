import 'package:flutter/material.dart';

class GenericInputField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final IconData iconData;
  final Function(String?, BuildContext) validateFunction;
  final Function(String) onSaved;
  final TextInputType? keyboardType;
  final Widget? sufixIconButton;
  final TextEditingController? controller;
  final String? initialValue;
  final bool readOnly;

  const GenericInputField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.iconData,
    required this.validateFunction,
    required this.onSaved,
    this.keyboardType,
    this.sufixIconButton,
    this.controller,
    this.initialValue,
    this.readOnly = false,
  });

  @override
  State<GenericInputField> createState() => _GenericInputFieldState();
}

class _GenericInputFieldState extends State<GenericInputField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Label of the text field
          label(widget.labelText),

          // The text field
          SizedBox(
            child: TextFormField(
              readOnly: widget.readOnly,
              initialValue: widget.initialValue,
              keyboardType: widget.keyboardType,
              controller: widget.controller,
              decoration: InputDecoration(
                hintText: widget.hintText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerLow,
                prefixIcon: Icon(widget.iconData),
                suffixIcon: widget.sufixIconButton,
                errorMaxLines: 5,
              ),
              validator: (value) {
                return widget.validateFunction(value, context);
              },
              onSaved: (value) => widget.onSaved(value ?? ''),
            ),
          ),
        ],
      ),
    );
  }

  Widget label(String text) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Text(
      text,
      style: textTheme.titleSmall?.copyWith(color: colorScheme.onSurface),
    );
  }
}
