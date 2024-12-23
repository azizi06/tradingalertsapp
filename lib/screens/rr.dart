import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksalertapp/components/my_IconButton.dart';
import 'package:stocksalertapp/components/my_bottomAppBar.dart';
import 'package:stocksalertapp/components/my_stockSquareCard.dart';
import 'package:stocksalertapp/helpers/design.dart';
import 'package:stocksalertapp/models/coin_model.dart';
import 'package:stocksalertapp/state_management/coin_block/coin_block_provider.dart';
import 'package:stocksalertapp/state_management/coin_block/coin_event.dart';
import 'package:stocksalertapp/state_management/coin_block/coin_state.dart';

class MyExplorePage extends StatefulWidget {
  const MyExplorePage({super.key});

  @override
  State<MyExplorePage> createState() => _MyExplorePageState();
}

class _MyExplorePageState extends State<MyExplorePage> {
  @override
  Widget build(BuildContext context) {
    final coinBloC = context.read<CoinBlockProvider>();
    Design design = Design(context);
    List<CoinModel> coins = [];
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: AppBar(
            leading: IconButton(
                onPressed: () => {coinBloC.add(CoinListInitEvent())},
                icon: Icon(Icons.refresh)),
          ),
        ),
        bottomNavigationBar: MyBottomAppBar(),
        body: Column(
          children: [
            Container(
              height: 50.0,
              child: Center(child: Text('Header Section')),
            ),
            BlocConsumer<CoinBlockProvider, CoinState>(
              listener: (context, state) {
                if (state.coins.isNotEmpty) {
                  setState(() {
                    coins = state.coins;
                    print("setState");
                    print("Length of coins: ${coins.length}");
                  });
                }
              },
              builder: (context, state) {
                return Expanded(
                    //height: 400,
                    child: GridView.builder(
                        itemCount: 11,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Number of columns in the grid
                          crossAxisSpacing: 5.0, // Spacing between columns
                          mainAxisSpacing: 8.0, // Spacing between rows
                          childAspectRatio: 1, // Aspect ratio of each item
                        ),
                        itemBuilder: (context, index) {
                          print("in screen YO");
                          print(coins.length);
                          return MyStockSquareCard(
                            id: coins[index].id,
                            currentPrice: coins[index].currentPrice,
                          );
                        }));
              },
            )
          ],
        ),
      ),
    );
  }
}
