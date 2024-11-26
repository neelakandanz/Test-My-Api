import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CopyUtils {
  /// Copies the given [text] to the clipboard and shows a [SnackBar] confirmation.
  static void copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Copied to clipboard!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
