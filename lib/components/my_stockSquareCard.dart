import 'package:flutter/material.dart';

class MyStockSquareCard extends StatelessWidget {
  const MyStockSquareCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1),        
      ),
   
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Hello",
             // style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
