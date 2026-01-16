import 'package:flutter/material.dart';

class SubtitleTextWidget extends StatelessWidget {
  final String label;
  final double fontSize;
  final FontWeight fontWeight;

  const SubtitleTextWidget({
    super.key,
    required this.label,
    this.fontSize = 14,
    required this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[300]
            : Colors.grey[600],
      ),
    );
  }
}
