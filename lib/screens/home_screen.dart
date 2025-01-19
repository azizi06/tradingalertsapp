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
    getCoinMarket();
    _loadFavorites();
    final coinBloC = context.read<CoinBlockProvider>();
    coinBloC.add(CoinListInitEvent());
  }

  void fetchNFTListAndModels() async {
    Dio dio = Dio();

    // First, fetch the NFT list (for example, from an API endpoint)
    try {
      var listResponse = await dio.get('https://api.coingecko.com/api/v3/nfts/list');
      if (listResponse.statusCode == 200) {
        List<dynamic> nftList = listResponse.data;
        print('NFT List fetched successfully!');

        // Fetch model details for each NFT in the list
        for (var nft in nftList.take(30)) {
          // Limiting to top 30 NFTs
          String nftId = nft['id'];
          String contractAddress = nft['contract_address'];

          try {
            var modelResponse = await dio.get(
                'https://api.coingecko.com/api/v3/nfts/$nftId',
               // queryParameters: {'contract_address': contractAddress}
               );

            if (modelResponse.statusCode == 200) {
              print('NFT ID: $nftId');
              print('NFT Model Details: ${modelResponse.data}');
            } else {
              print('Failed to fetch model for NFT with ID: $nftId');
            }
          } catch (e) {
            print('Error fetching model for NFT $nftId: $e');
          }
        }
      } else {
        print('Failed to fetch NFT list');
      }
    } catch (e) {
      print('Error fetching NFT list: $e');
    }
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

  bool isRefreshing = true;
  List? coinMarket = [];
  List<CoinModel> coinMarketList = [];

  Future<List<CoinModel>?> getCoinMarket() async {
    const url =
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&sparkline=true';

    setState(() {
      isRefreshing = true;
    });

    var response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    setState(() {
      isRefreshing = false;
    });

    if (response.statusCode == 200) {
      var data = response.body;
      coinMarketList = coinModelFromJson(data);
      setState(() {
        coinMarket = coinMarketList;
      });
    } else {
      print("Erreur: ${response.statusCode}");
    }
  }

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
                  padding: const EdgeInsets.only(left: 14, top: 40),
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
                              fontSize: 30,
                            ),
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

                SizedBox(height: myHeight * 0.02),
                Expanded(
                    child: SizedBox(
                  height: 1,
                )),
                Container(
                  height: 200,
                  child: BlocBuilder<CoinBlockProvider, CoinState>(
                    builder: (context, state) {
                      if (state is CoinState) {
                        // Replace with the actual state for loaded data
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
                        SizedBox(height: myHeight * 0.02),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: myWidth * 0.08),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Favorites',
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: myHeight * 0.02),

                        // Indicateur de rafraîchissement ou liste des actifs
                        isRefreshing
                            ? Center(child: CircularProgressIndicator())
                            : ListView.builder(
                                itemCount: coinMarket!.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  if (_favcoins
                                      .contains(coinMarket![index].id)) {
                                    return MyCoincard(
                                      item: coinMarket![index],
                                    );
                                  }
                                },
                              ),
                        SizedBox(height: myHeight * 0.02),

                        // Affichage horizontal des coins recommandés
                        Container(
                          height: myHeight * 0.3,
                        ),
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
