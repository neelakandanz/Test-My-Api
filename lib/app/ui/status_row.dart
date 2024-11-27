import 'package:flutter/material.dart';

class StatusRow extends StatelessWidget {
  const StatusRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Align items to the start
      children: [
        // Status text
        Text(
          'Status: 200 OK',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        // Size text
        Text(
          'Size: 1.87 KB',
          style: TextStyle(fontSize: 16),
        ),
        // Time text
        Text(
          'Time: 37.27 s',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
