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
  // Initialisation de l'état au démarrage
  @override
  void initState() {
    super.initState();
    getCoinMarket(); // Récupère les informations du marché des cryptos
  }

  bool isRefreshing = true; // Indicateur pour savoir si les données sont en train de se rafraîchir
  List? coinMarket = []; // Liste des monnaies (crypto)
  var coinMarketList; // Variable temporaire pour stocker les données récupérées

  // Méthode pour récupérer les données du marché des cryptos
  Future<List<CoinModel>?> getCoinMarket() async {
    const url = 'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&sparkline=true';

    setState(() {
      isRefreshing = true; // Début du rafraîchissement
    });

    var response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    setState(() {
      isRefreshing = false; // Fin du rafraîchissement
    });

    if (response.statusCode == 200) {
      var data = response.body;
      coinMarketList = coinModelFromJson(data);
      setState(() {
        coinMarket = coinMarketList; // Mise à jour des données du marché
      });
    } else {
      print("Erreur: ${response.statusCode}"); // Affichage d'une erreur si la requête échoue
    }
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      // Début du corps de la page
      body: SingleChildScrollView(
        child: Container(
          height: myHeight,
          width: myWidth,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Entête avec des options (portefeuille, coins top 10, etc.)
              Padding(
                padding: EdgeInsets.symmetric(vertical: myHeight * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: myWidth * 0.02, vertical: myHeight * 0.005),
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 60, 60, 60).withOpacity(0.5),
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        'Portefeuille principal',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
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
              
              
              // Affichage du solde du portefeuille
              Padding(
                padding: EdgeInsets.symmetric(horizontal: myWidth * 0.07),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$ 1,000',
                      style: TextStyle(fontSize: 35),
                    ),
                    Container(
                      padding: EdgeInsets.all(myWidth * 0.02),
                      height: myHeight * 0.05,
                      width: myWidth * 0.1,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.5)),
                    ),
                  ],
                ),
              ),
              
              // Affichage de l'augmentation en pourcentage
              Padding(
                padding: EdgeInsets.symmetric(horizontal: myWidth * 0.07),
                child: Row(
                  children: [
                    Text(
                      '+162% depuis le début',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(height: myHeight * 0.02),

              // Affichage de la liste des coins et recommandations
              Container(
                height: myHeight * 0.7,
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
                              itemCount: 4,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Item(
                                  item: coinMarket![index], // Affichage des items
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
                              item: coinMarket![index], // Affichage des items recommandés
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
