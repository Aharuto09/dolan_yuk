import 'package:flutter/material.dart';

class DolanField extends StatelessWidget {
  const DolanField(
      {super.key, required this.label, required this.controller, this.suffix});
  final String label;
  final TextEditingController controller;
  final Widget? suffix;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: suffix,
        label: Text(label),
        border: const OutlineInputBorder(),
      ),
    );
  }
}
