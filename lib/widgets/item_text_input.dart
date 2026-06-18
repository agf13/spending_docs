import 'package:flutter/material.dart';

// Widget to handle error highlighting and user input
class ItemTextInput extends StatefulWidget {
  final String labelText;
  final String hintText;
  final TextEditingController textController;
  final Icon prefixIcon;
  final TextInputType keyboardType;
  final FormFieldValidator<String> validationFunction;

  const ItemTextInput({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.textController,
    required this.prefixIcon,
    required this.keyboardType,
    required this.validationFunction,
  });

  @override
  State<ItemTextInput> createState() {
    return _ItemTextInputState();
  }
}

class _ItemTextInputState extends State<ItemTextInput> {
  // Creating the TextField to handle input and error highlighting
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        prefixIcon: widget.prefixIcon,
      ),
      keyboardType: widget.keyboardType,
      controller: widget.textController,
      validator: widget.validationFunction,
    );
  }
}
