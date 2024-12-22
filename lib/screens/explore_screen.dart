import 'package:flutter/material.dart';
import 'package:stocksalertapp/components/my_bottomAppBar.dart';

class MyExplorePage extends StatefulWidget {
  const MyExplorePage({super.key});

  @override
  State<MyExplorePage> createState() => _MyExplorePageState();
}

class _MyExplorePageState extends State<MyExplorePage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: MyBottomAppBar(),
      body: Center(child: Text("Explore"),),

    );
  }
}