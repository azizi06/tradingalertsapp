import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stocksalertapp/components/my_IconButton.dart';
import 'package:stocksalertapp/components/my_button.dart';
import 'package:stocksalertapp/components/my_candelChart.dart';
import 'package:stocksalertapp/components/my_coinInfo.dart';
import 'package:stocksalertapp/helpers/design.dart';
import 'package:stocksalertapp/models/candel_model.dart';
import 'package:stocksalertapp/models/coin_model.dart';
import 'package:stocksalertapp/state_management/coin_block/coin_block_provider.dart';
import 'package:stocksalertapp/state_management/coin_block/coin_state.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/services.dart' show rootBundle;

class MyChartScreen extends StatefulWidget {
  final String coinID;

  const MyChartScreen({
    super.key,
    required this.coinID,
  });

  @override
  State<MyChartScreen> createState() => _MyChartScreenState();
}

class _MyChartScreenState extends State<MyChartScreen> {
  late List<CandelModel> chartData = [];



  Future<List<dynamic>> fetchChartData() async {
    final dio = Dio();
    print("Fetching Data From CoinGecko");
    try {
      final response = await dio.get( 'https://api.coingecko.com/api/v3/coins/${widget.coinID}/ohlc', queryParameters: { 'vs_currency': 'usd', 'days': '30', 'precision': '5', }, );

      if (response.statusCode == 200) {
        // Decode response data (Dio already decodes JSON for you)
        return response.data; // This will be a List<dynamic>
      } else {
        throw Exception(
            'Failed to load coins. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to load coins: $e');
      throw Exception('Failed to load coins: $e');
    }
  }





  Future<List<dynamic>> loadJsonData() async {
    // Load the JSON file
    print("Loading Data From bitcoin.json");
    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/bitcoin.json');
      // Decode the JSON string into a Dart object
      final List<dynamic> jsonData = jsonDecode(jsonString);
      print(jsonData);

      return jsonData;
    } catch (e) {
      print('Error reading local JSON file: $e');
      throw Exception('Error reading local JSON file: $e');
    }
  }

  @override
  void initState() {
    
    getChartData();
    super.initState();
  }

  void getChartData() async {
    var fetchedData = await loadJsonData();
    print(fetchedData);
    for (var item in fetchedData) {
      chartData.add(CandelModel.fromJson(item));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Design design = Design(context);

    return BlocBuilder<CoinBlockProvider, CoinState>(
      builder: (context, state) {
        CoinModel? coin;
        for (CoinModel c in state.coins) {
          if (c.id == widget.coinID) {
            coin = c;
            break;
          }
        }
        if (coin == null) {
          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        print("yaaaaaaaaa");
                        getChartData();
                      });
                    },
                    icon: Icon(Icons.refresh_outlined))
              ],
              leading: IconButton(
                onPressed: () => context.pop(),
                icon: Icon(Icons.arrow_back_ios),
              ),
              title: Text('Coin not found'),
            ),
            body: Center(
              child: Text('Coin with ID ${widget.coinID} not found.'),
            ),
          );
        }
        List<MapEntry<String, String>> coinInfo = coin.toMap().entries.toList();
        return DefaultTabController(
          length: 2,
          initialIndex: 1,
          child: Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () {
                      print("yaaaaaaaaa");
                      getChartData();
                    },
                    icon: Icon(Icons.refresh_outlined))
              ],
              leading: IconButton(
                  onPressed: () => context.pop(),
                  icon: Icon(Icons.arrow_back_ios)),
              title: Row(
                children: [
                  CircleAvatar(backgroundImage: NetworkImage(coin.image)),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    coin.id,
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              bottom: TabBar(tabs: [
                Tab(
                  text: "chart",
                ),
                Tab(
                  text: "info",
                )
              ]),
            ),
            body: TabBarView(
              children: [
                Column(
                  children: [
                    Expanded(
                      //height: 700,
                      child: Center(
                        child: MyCandelchart(chartData: chartData),
                      ),
                    ),
                    Card(
                      child: Container(
                        height: 60,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            MyIconButton(
                              onPressed: () => "",
                              color: design.secondary,
                              icon: Icons.alarm_add_rounded,
                              text: "add alert",
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                          height: 40,
                          width: double.infinity,
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                '${coin.id} info',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600,
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ],
                          )),
                      Wrap(
                        children: coinInfo.map((entry) {
                          return MyCoininfo(
                            item: entry.key,
                            value: entry.value,
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
