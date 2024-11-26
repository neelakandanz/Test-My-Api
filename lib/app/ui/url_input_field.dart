import 'package:flutter/material.dart';

class UrlInputField extends StatelessWidget {
  final TextEditingController controller;

  const UrlInputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
          labelText: 'API URL',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
