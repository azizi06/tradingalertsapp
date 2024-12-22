//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksalertapp/components/my_IconButton.dart';
import 'package:stocksalertapp/components/my_button.dart';
import 'package:stocksalertapp/components/my_textfield.dart';
import 'package:stocksalertapp/helpers/design.dart';
import 'package:stocksalertapp/models/theme_enum.dart';
import 'package:stocksalertapp/state_management/theme_bloc/theme_bloc_provider.dart';
import 'package:stocksalertapp/state_management/theme_bloc/theme_event.dart';

class MyTestPage extends StatefulWidget {
  const MyTestPage({super.key});

  @override
  State<MyTestPage> createState() => _MyTestPageState();
}

class _MyTestPageState extends State<MyTestPage> {
  TextEditingController wordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeBloc = context.read<ThemeBlocProvider>();
    Design design = Design(context);

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 110,
          ),
          SizedBox(
              height: 60,
              width: 300,
              child: MyTextField(
                  hintText: "algee",
                  myController: wordController,
                  myIcon: Icon(Icons.add_ic_call_outlined),
                  isObscure: false)),
          MyButton(onPressed: () => {themeBloc.add(ThemeChangeEvent(ThemeType.dark))}, text: "Dark", color: design.primary),
          SizedBox(height: 10,),
          MyButton(onPressed: () => {themeBloc.add(ThemeChangeEvent(ThemeType.light))}, text: "light", color: design.secondary),
          SizedBox(height: 10,),
        
          MyButton(onPressed: () => {themeBloc.add(ThemeChangeEvent(ThemeType.lightMediumContrast))}, text: "light", color: design.error),
          SizedBox(height: 10,),
          MyIconButton(
              onPressed: () => "", color: design.error, icon: Icons.headphones),
          SizedBox(
              height: 40,
              width: 180,
              child: MyIconButton(
                onPressed: () => "",
                color: design.error,
                icon: Icons.settings,
                text: "Settings",
              )),
          Center(
              child: Text(
            "Azizi",
            style: TextStyle(
                fontFamily: 'Roboto', height: 20, fontWeight: FontWeight.w500),
          )),
        ],
      ),
    );
  }
}
