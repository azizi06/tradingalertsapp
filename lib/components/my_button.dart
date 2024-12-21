import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color color;



  const MyButton({
    required this.onPressed,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
      final theme = Theme.of(context);
  final onColor = theme.colorScheme.onPrimary;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color, // Use the color passed to the button
         shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), 
        ),
        
      ),
      child: Text(
        text,
        style: TextStyle(color: onColor,fontWeight: FontWeight.w400,fontSize: 17),
      ),
    );
  }
}
