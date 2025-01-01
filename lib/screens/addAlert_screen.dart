import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stocksalertapp/models/coin_model.dart';
import 'package:stocksalertapp/services/firebase_messaging_service.dart';
import 'package:stocksalertapp/components/my_IconButton.dart';
import 'package:stocksalertapp/components/my_textfield.dart';
import 'package:stocksalertapp/helpers/design.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:stocksalertapp/models/alert_model.dart';
import 'package:stocksalertapp/services/firestore_service.dart';

import 'package:http/http.dart' as http;
import 'package:stocksalertapp/state_management/coin_block/coin_block_provider.dart';
import 'package:stocksalertapp/state_management/coin_block/coin_event.dart';
import 'package:stocksalertapp/state_management/coin_block/coin_state.dart';

class MyAddalertPage extends StatefulWidget {
  final String coinID;
  final String coinImage;

  MyAddalertPage({super.key, required this.coinID, required this.coinImage});

  @override
  _MyAddalertPageState createState() => _MyAddalertPageState();
}

class _MyAddalertPageState extends State<MyAddalertPage> {
  String selectedChoice = "";
  TextEditingController _priceController = TextEditingController();
  TextEditingController _valueController = TextEditingController();

  String? sprice;
  String? fcmToken;

  @override
  void initState() {
    super.initState();
    _retrieveFCMToken();
    _initPrice();
  }

  Future<double?> getCoinPrice(String coin) async {
    try {
      final response = await http.get(Uri.parse(
          'https://api.coingecko.com/api/v3/simple/price?ids=$coin&vs_currencies=usd'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey(coin)) {
          return data[coin]['usd'];
        }
      }
    } catch (e) {
      debugPrint("Erreur lors de la récupération du prix : $e");
    }
    return null;
  }

  void _retrieveFCMToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('fcmToken');
    if (token != null) {
      print('Retrieved FCM Token: $token');
      setState(() {
        fcmToken = token;
      });
    } else {
      print('No FCM Token found in SharedPreferences');
    }
  }

  Future<void> _initPrice() async {
    double? fetchedPrice = await getCoinPrice(widget.coinID);
    setState(() {
      sprice = fetchedPrice?.toString();
      _priceController.text = sprice ?? '';
      print("new priceeeeeeeeeeeeeee  $sprice");
    });
  }

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
        body: BlocConsumer<CoinBlockProvider, CoinState>(
            listener: (context, state) {},
            builder: (context, state) {
              CoinModel coin =
                  state.coins.firstWhere((coin) => coin.id == widget.coinID);
              _priceController.text = coin.currentPrice.toString();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 60,
                  ),
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
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: MyTextField(
                            hintText: "",
                            myController: _priceController,
                            myIcon: Icon(Icons.euro),
                            isObscure: false,
                          ),
                        ),
                        SizedBox(width: 8.0),
                        MyIconButton(
                          onPressed: ()  { _priceController.text = coin.currentPrice.toString();},
                          color: design.secondary,
                          icon: Icons.refresh_rounded,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: MyTextField(
                      hintText: "value",
                      myController: _valueController,
                      myIcon: Icon(Icons.numbers),
                      isObscure: false,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: MyIconButton(
                      onPressed: () {
                        double? price =
                            double.tryParse(_priceController.text) ?? 0.0;
                        double? value =
                            double.tryParse(_valueController.text) ?? 0.0;

                        if (selectedChoice.isNotEmpty &&
                            fcmToken != null &&
                            price != 0.0 &&
                            value != 0.0) {
                          AlertService alertService = AlertService();

                          AlertModel newAlert = AlertModel(
                              coinID: widget.coinID,
                              type: selectedChoice,
                              coinPrice: price,
                              value: value,
                              createdAt: DateTime.now(),
                              fcmToken: fcmToken ?? "",
                              isNotified: false);

                          alertService.addAlert(newAlert);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Alert added for: $selectedChoice'),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content:
                                  Text('Please enter the required fields !'),
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
              );
            }),
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
  _TextWidgetWithBottomSheetState createState() =>
      _TextWidgetWithBottomSheetState();
}

class _TextWidgetWithBottomSheetState extends State<TextWidgetWithBottomSheet> {
  final List<String> choices = [
    "Price is over",
    "Price is below",
    "24H change is over",
    "24H change is below"
  ];

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
