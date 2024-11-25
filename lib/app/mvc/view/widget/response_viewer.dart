import 'package:flutter/material.dart';

class ResponseViewer extends StatelessWidget {
  final String response;

  const ResponseViewer({
    Key? key,
    required this.response,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
      child: SingleChildScrollView(
        child: SelectableText(
          response.isEmpty ? 'No response yet' : response,
          style: TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
