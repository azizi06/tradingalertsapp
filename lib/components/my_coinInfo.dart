import 'package:flutter/material.dart';

class MyCoininfo extends StatelessWidget {
  final String item;
  final String value;
  const MyCoininfo({super.key,required this.item,required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      
      title:  Text(
              item,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(value),
    );
  }
}
