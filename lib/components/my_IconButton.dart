import 'package:flutter/material.dart';

class MyIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? text;
  final Color color;
  final IconData icon;

  const MyIconButton({
    required this.onPressed,
    this.text,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
      final theme = Theme.of(context);
      final onColor = theme.colorScheme.onPrimary;
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white), // Icon color ensures good contrast
      label: text != null ? Text(text!,style: TextStyle(color: onColor),) : Container(), // Display text if provided
      style: ElevatedButton.styleFrom(
        backgroundColor: color, // Use the color passed to the button
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
