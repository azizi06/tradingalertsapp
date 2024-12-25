import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:go_router/go_router.dart';
import 'package:stocksalertapp/components/my_bottomAppBar.dart';

class MyAlarmPage extends StatefulWidget {
  const MyAlarmPage({super.key});

  @override
  State<MyAlarmPage> createState() => _MyAlarmPageState();
}

class _MyAlarmPageState extends State<MyAlarmPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MyBottomAppBar(),
      body: Center(child: Text("Alarm"),),
    );
  }
}