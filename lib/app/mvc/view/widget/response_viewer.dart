import 'package:flutter/material.dart';

import '../../../utils/pretty_json.dart';

class ResponseViewer extends StatelessWidget {
  final String response;

  const ResponseViewer({
    super.key,
    required this.response,
  });

  @override
  Widget build(BuildContext context) {
    // Use the reusable formatResponse function
    final formattedResponse = formatResponse(response);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: MediaQuery.of(context).size.height /4,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(8),
        child: Expanded(
          child: SingleChildScrollView(
            child: SelectableText(
              formattedResponse,
              style: const TextStyle(
                fontSize: 14,
                fontFamily: 'Courier', // Monospaced font for better readability
              ),
            ),
          ),
        ),
      ),
    );
  }
}
