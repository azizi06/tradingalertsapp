import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stocksalertapp/components/my_IconButton.dart';
import 'package:stocksalertapp/helpers/design.dart';

class MyAddalertPage extends StatefulWidget {
  final String coinID;
  final String coinImage;

  MyAddalertPage({super.key, required this.coinID, required this.coinImage});

  @override
  _MyAddalertPageState createState() => _MyAddalertPageState();
}

class _MyAddalertPageState extends State<MyAddalertPage> {
  String selectedChoice = "";
  final List<String> choices = ["Choice 1", "Choice 2", "Choice 3", "Choice 4"];

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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: MyIconButton(
                onPressed: () {
                  if (selectedChoice.isNotEmpty) {
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
  final List<String> choices = ["Choice 1", "Choice 2", "Choice 3", "Choice 4"];
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
