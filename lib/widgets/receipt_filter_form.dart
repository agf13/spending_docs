import 'package:flutter/material.dart';

class ReceiptFilterForm extends StatefulWidget {
  final VoidCallback onClose;

  const ReceiptFilterForm({super.key, required this.onClose});

  @override
  State<ReceiptFilterForm> createState() => _ReceiptFilterState();
}

class _ReceiptFilterState extends State<ReceiptFilterForm> {
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _key,
      child: Column(children: [Text("Filter by")]),
    );
  }
}
