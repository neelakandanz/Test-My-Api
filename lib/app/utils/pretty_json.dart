import 'dart:convert';

/// Formats a given response string as pretty JSON if valid, or returns the raw string otherwise.
String formatResponse(String response) {
  try {
    // Attempt to decode and format the response as JSON
    final decodedJson = json.decode(response);
    return const JsonEncoder.withIndent('  ').convert(decodedJson);
  } catch (e) {
    // If not JSON, return the raw response
    return response;
  }
}
