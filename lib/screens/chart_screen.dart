import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stocksalertapp/components/my_coinInfo.dart';
import 'package:stocksalertapp/models/coin_model.dart';
import 'package:stocksalertapp/state_management/coin_block/coin_block_provider.dart';
import 'package:stocksalertapp/state_management/coin_block/coin_state.dart';

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
  @override
  Widget build(BuildContext context) {
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
        return 
         DefaultTabController(
          length: 2,
          initialIndex: 1,
          child: Scaffold(
            appBar: AppBar(
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
                Tab(text: "chart",),
                Tab(text: "info",)
              ]),
            ),
            body: TabBarView(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        height: 700,
                        child: Center(
                          child: Text("Coin Chart is Loading"),
                        ),
                      ),
                     
                    ],
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    children: [
                       Text("${coin.id} info"),
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
