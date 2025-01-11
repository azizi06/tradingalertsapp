import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stocksalertapp/components/item.dart';
import 'package:stocksalertapp/components/item2.dart';
import 'package:stocksalertapp/models/coinModal.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    getCoinMarket();
  }

  bool isRefreshing = true;
  List? coinMarket = [];
  var coinMarketList;

  Future<List<CoinModel>?> getCoinMarket() async {
    const url = 'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&sparkline=true';

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

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: myHeight,
          width: myWidth,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Entête avec des options (Coins Top 10, etc.)
              Padding(
                padding: EdgeInsets.symmetric(vertical: myHeight * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Top 10 Coins',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Expérimental',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),

              SizedBox(height: myHeight * 0.02),

              // Affichage de la liste des coins et recommandations
              Container(
                height: myHeight * 0.8,
                width: myWidth,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 5,
                          color: Colors.grey.shade300,
                          spreadRadius: 3,
                          offset: Offset(0, 3))
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    )),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: myHeight * 0.03),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: myWidth * 0.08),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Actifs',
                              style: TextStyle(fontSize: 20),
                            ),
                            Icon(Icons.add),
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
                                return Item(
                                  item: coinMarket![index],
                                );
                              },
                            ),
                      SizedBox(height: myHeight * 0.02),

                      // Recommandation pour acheter des coins
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: myWidth * 0.05),
                        child: Row(
                          children: [
                            Text(
                              'Recommandé à acheter',
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: myHeight * 0.02),

                      // Affichage horizontal des coins recommandés
                      Container(
                        height: myHeight * 0.3,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: coinMarket!.length,
                          itemBuilder: (context, index) {
                            return Item2(
                              item: coinMarket![index],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
