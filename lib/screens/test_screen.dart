//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:stocksalertapp/components/my_IconButton.dart';
import 'package:stocksalertapp/components/my_button.dart';
import 'package:stocksalertapp/components/my_textfield.dart';
import 'package:stocksalertapp/helpers/design.dart';


class MyTestPage extends StatefulWidget {
  const MyTestPage({super.key});

  @override
  State<MyTestPage> createState() => _MyTestPageState();
}

class _MyTestPageState extends State<MyTestPage> {
   TextEditingController wordController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
  Design design = Design(context);

    return Scaffold(
      body: Column(
        children: [ 
          SizedBox(height: 110,),
          SizedBox(
            height: 60,
            width: 300,
           
            child : MyTextField(hintText: "algee", myController: wordController, myIcon: Icon(Icons.add_ic_call_outlined), isObscure: false)
            ),
            MyButton(onPressed: ()=> "", text: "azizi", color: design.primary),

            MyButton(onPressed: ()=> "", text: "azizi", color: design.secondary),
            MyIconButton(onPressed: ()=>"", color: design.error, icon: Icons.headphones),
            SizedBox(height: 40,
            width: 180,
              child: MyIconButton(onPressed: ()=>"", color: design.error, icon: Icons.settings,text: "Settings",)),


                
      
                   Center(child: Text("Azizi",style: TextStyle(fontFamily:'Roboto',height: 20,fontWeight: FontWeight.w500),)),
        ],
      ),
    );
  }
}
