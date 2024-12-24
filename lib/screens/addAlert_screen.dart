import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyAddalertPage extends StatelessWidget {
  final String coinID;
  final String coinImage;
  MyAddalertPage({super.key, required this.coinID, required this.coinImage});

  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => context.pop(), icon: Icon(Icons.arrow_back_ios)),
        title: Row(
          children: [
            CircleAvatar(
                backgroundImage: NetworkImage(coinImage)),
            SizedBox(
              width: 10,
            ),
            Text(
              coinID,
              style: TextStyle(fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
      body: Column(
        children: [],
      ),
    ));
  }
}
