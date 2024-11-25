import 'package:flutter/material.dart';

class ExpandableInput extends StatelessWidget {
  final String title;
  final TextEditingController controller;

  const ExpandableInput({
    Key? key,
    required this.title,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: title == 'Headers'
                  ? '{"key": "value"}'
                  : 'Enter body data (JSON format)',
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
