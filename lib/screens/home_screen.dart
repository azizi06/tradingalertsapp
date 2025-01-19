import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stocksalertapp/components/my_coinCard.dart';
import 'package:stocksalertapp/components/my_bottomAppBar.dart';
import 'package:stocksalertapp/components/my_stockSquareCard.dart';
import 'package:stocksalertapp/helpers/design.dart';

import 'package:stocksalertapp/models/coin_model.dart';

import 'package:stocksalertapp/models/sparklineIn7D.dart';
import 'package:stocksalertapp/state_management/coin_block/coin_block_provider.dart';
import 'package:stocksalertapp/state_management/coin_block/coin_event.dart';
import 'package:stocksalertapp/state_management/coin_block/coin_state.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> _favcoins = [
    "bitcoin",
    "ethereum",
    "ripple",
    "litecoin",
    "cardano",
    "polkadot",
    "binancecoin",
    "dogecoin",
    "solana",
    "pepecoin"
  ];

  @override
  void initState() {
    super.initState();

    _loadFavorites();
    final coinBloC = context.read<CoinBlockProvider>();
    coinBloC.add(CoinListInitEvent());
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedFavorites = prefs.getStringList('favorites');
    if (savedFavorites != null) {
      setState(() {
        _favcoins = savedFavorites;
      });
    }
  }

  bool isRefreshing = false;

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    Design design = Design(context);

    return Scaffold(
        //appBar: PreferredSize(preferredSize: Size., child: Row()),
        bottomNavigationBar: MyBottomAppBar(),
        body: SingleChildScrollView(
          child: Container(
            height: myHeight,
            width: myWidth,
            //color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 14, top: 55),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Trading Alerts",
                            style: TextStyle(
                                fontSize: 35, fontWeight: FontWeight.w800),
                          ),
                          Text(
                            "Stay Up-to-Date",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      Spacer(),
                      Align(
                        alignment: Alignment.centerRight,
                      ),
                    ],
                  ),
                ),
                // Entête avec des options (Coins Top 10, etc.)

                SizedBox(height: myHeight * 0.01),

                Container(
                  height: 7,
                  color: design.colorScheme.inverseSurface,
                ),

                Padding(
                  padding: EdgeInsets.only(left: 14),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Favorites',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 200,
                  child: BlocBuilder<CoinBlockProvider, CoinState>(
                    builder: (context, state) {
                      if (state is CoinState) {
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _favcoins.length,
                          itemBuilder: (context, index) {
                            final id = _favcoins[index];
                            final coin = state.coins.firstWhere(
                              (coin) => coin.id == id,
                              orElse: () => CoinModel(
                                  id: "",
                                  symbol: "",
                                  name: "",
                                  image: "",
                                  currentPrice: 0,
                                  marketCap: 0,
                                  marketCapRank: 0,
                                  fullyDilutedValuation: 0,
                                  totalVolume: 0,
                                  high24h: 0,
                                  low24h: 0,
                                  priceChange24h: 0,
                                  priceChangePercentage24h: 0,
                                  marketCapChange24h: 0,
                                  marketCapChangePercentage24h: 0,
                                  circulatingSupply: 0,
                                  totalSupply: 0,
                                  maxSupply:
                                      0), // Return null if the coin is not found
                            );

                            if (coin.id != "") {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  width: 200,
                                  child: MyStockSquareCard(
                                    id: coin.id,
                                    image: coin.image,
                                    currentPrice: coin.currentPrice,
                                    priceColor: (coin.priceChange24h >= 0)
                                        ? Colors.green
                                        : Colors.red,
                                    change: coin.marketCapChangePercentage24h,
                                  ),
                                ),
                              );
                            } else {
                              return SizedBox();
                            }
                          },
                        );
                      } else {
                        return Center(child: Text('Unexpected state!'));
                      }
                    },
                  ),
                ),

                Container(
                  height: myHeight * 0.45,
                  width: myWidth,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 1,
                            color: design.colorScheme.surfaceBright,
                            spreadRadius: 3,
                            offset: Offset(0, 3))
                      ],
                      //  color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      )),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: myHeight * 0.005),

                        // Indicateur de rafraîchissement ou liste des actifs
                        isRefreshing
                            ? Center(child: CircularProgressIndicator())
                            : BlocBuilder<CoinBlockProvider, CoinState>(
                                builder: (context, state) {
                                return ListView.builder(
                                  itemCount: state.coins.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 1.0, top: 7, bottom: 8),
                                        child: MyCoincard(
                                          coin: state.coins[index],
                                        ));
                                  },
                                );
                              }),
                        SizedBox(
                          height: 350,
                        )

                        // Affichage horizontal des coins recommandés
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
