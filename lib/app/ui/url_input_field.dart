import 'package:flutter/material.dart';

class UrlInputField extends StatelessWidget {
  final TextEditingController controller;

  const UrlInputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: const InputDecoration(
        labelText: 'API URL',
        border: OutlineInputBorder(),
        // Customize border colors
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.black), // Border color when not focused
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.black), // Border color when focused
        ),
      ),
    );
  }
}
