import 'package:flutter/material.dart';

class StatusRow extends StatelessWidget {
  final String status;
  final String size;
  final String time;

  const StatusRow({
    super.key,
    required this.status,
    required this.size,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Align items with equal space
      children: [
        // Status text
        Text(
          'Status: $status',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        // Size text
        Text(
          'Size: $size',
          style: const TextStyle(fontSize: 16),
        ),
        // Time text
        Text(
          'Time: $time',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
