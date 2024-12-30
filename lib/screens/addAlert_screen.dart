import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stocksalertapp/components/my_IconButton.dart';
import 'package:stocksalertapp/components/my_textfield.dart';
import 'package:stocksalertapp/helpers/design.dart';
import 'package:stocksalertapp/models/alert_model.dart';

class MyAddalertPage extends StatefulWidget {
  final String coinID;
  final String coinImage;

  MyAddalertPage({super.key, required this.coinID, required this.coinImage});

  @override
  _MyAddalertPageState createState() => _MyAddalertPageState();
}

class _MyAddalertPageState extends State<MyAddalertPage> {
  String selectedChoice = "";

  @override
  Widget build(BuildContext context) {
    Design design = Design(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: Icon(Icons.arrow_back_ios),
          ),
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.coinImage),
              ),
              SizedBox(width: 10),
              Text(
                widget.coinID,
                style: TextStyle(fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 60,),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextWidgetWithBottomSheet(
                initialChoice: selectedChoice,
                onChoiceSelected: (choice) {
                  setState(() {
                    selectedChoice = choice;
                  });
                },
              ),
            ),
            SizedBox(height: 30,),

           Padding(
  padding: const EdgeInsets.all(16.0),
  child: Row(
    children: [
      Expanded(
        child: MyTextField(
          hintText: "",
          myController: TextEditingController(),
          myIcon: Icon(Icons.euro),
          isObscure: false,
        ),
      ),
      SizedBox(width: 8.0), // Adds spacing between the text field and the button
      MyIconButton(
        onPressed: () => "",
        color: design.secondary,
        icon: Icons.refresh_rounded,
      ),
    ],
  ),
),

            SizedBox(height: 30,),
              
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: MyIconButton(
                onPressed: () {
                  if (selectedChoice.isNotEmpty) {
                    //AlertModel newAlert = AlertModel(coinID: widget.coinID, type: type, coinPrice: coinPrice)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Alert added for: $selectedChoice'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please select an option first!'),
                      ),
                    );
                  }
                },
                color: design.primary,
                icon: Icons.alarm_add_sharp,
                text: "Add Alert",
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TextWidgetWithBottomSheet extends StatefulWidget {
  final String initialChoice;
  final Function(String) onChoiceSelected;

  TextWidgetWithBottomSheet({
    required this.initialChoice,
    required this.onChoiceSelected,
  });

  @override
  _TextWidgetWithBottomSheetState createState() => _TextWidgetWithBottomSheetState();
}

class _TextWidgetWithBottomSheetState extends State<TextWidgetWithBottomSheet> {
  final List<String> choices = ["Price is over", "Price is below", "24H change is over", "24H change is below"];

  late String selectedChoice;

  @override
  void initState() {
    super.initState();
    selectedChoice = widget.initialChoice;
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: choices.map((choice) {
            return ListTile(
              title: Text(choice),
              onTap: () {
                setState(() {
                  selectedChoice = choice;
                });
                widget.onChoiceSelected(choice);
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showBottomSheet(context),
      child: TextField(
        readOnly: true,
        onTap: () => _showBottomSheet(context),
        decoration: InputDecoration(
          labelText: 'Select an option',
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.arrow_drop_down),
        ),
        controller: TextEditingController(
          text: selectedChoice,
        ),
      ),
    );
  }
}
