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
    getCoinMarket();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
<<<<<<< Updated upstream
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
              Padding(
                padding: EdgeInsets.symmetric(vertical: myHeight * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: myWidth * 0.02,
                          vertical: myHeight * 0.005),
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 60, 60, 60)
                              .withOpacity(0.5),
                          borderRadius: BorderRadius.circular(5)),
                      child: Text(
                        'Main portfolio',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Text(
                      'TOP 10 coins',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Exprimental',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
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
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: myWidth * 0.07),
                child: Row(
                  children: [
                    Text(
                      '+162% all time',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: myHeight * 0.02,
              ),
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
                      SizedBox(
                        height: myHeight * 0.03,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: myWidth * 0.08),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Assets',
                              style: TextStyle(fontSize: 20),
                            ),
                            Icon(Icons.add),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: myHeight * 0.02,
                      ),
                      isRefreching
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : ListView.builder(
                              itemCount: 4,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Item(
                                  item: coinMarket![index],
                                );
                              },
                            ),
                      SizedBox(
                        height: myHeight * 0.02,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: myWidth * 0.05),
                        child: Row(
                          children: [
                            Text(
                              'Recommend to Buy',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: myHeight * 0.02,
                      ),
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
              )
            ],
          ),
=======
    return Scaffold(
      bottomNavigationBar: MyBottomAppBar(), // Barre de navigation personnalisée
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Home",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20), // Espacement entre les widgets

            // Bouton pour naviguer vers SignupPage
            ElevatedButton(
              onPressed: () {
                GoRouter.of(context).go('/signup'); // Navigue vers SignupPage
              },
              child: const Text("Go to Signup Page"),
            ),

            // Bouton pour naviguer vers LoginPage
            TextButton(
              onPressed: () {
                GoRouter.of(context).go('/login'); // Navigue vers LoginPage
              },
              child: const Text(
                "Already have an account? Login",
                style: TextStyle(fontSize: 16),
              ),
            ),

            // Bouton pour naviguer vers Favoris
            ElevatedButton.icon(
              onPressed: () {
                GoRouter.of(context).go('/favorites'); // Navigue vers Favoris
              },
              icon: const Icon(Icons.favorite),
              label: const Text("Go to Favourites"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Couleur personnalisée
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
            ),
          ],
>>>>>>> Stashed changes
        ),
      ),
    );
  }
<<<<<<< Updated upstream

  bool isRefreching = true;

  List? coinMarket = [];
  var coinMarketList;

  Future<List<CoinModel>?> getCoinMarket() async {
    const url =
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&sparkline=true';

    setState(() {
      isRefreching = true;
    });
    var response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    setState(() {
      isRefreching = false;
    });
    if (response.statusCode == 200) {
      var x = response.body;
      coinMarketList = coinModelFromJson(x);
      setState(() {
        coinMarket = coinMarketList;
      });
    } else {
      print(response.statusCode);
    }
  }
=======
>>>>>>> Stashed changes
}
