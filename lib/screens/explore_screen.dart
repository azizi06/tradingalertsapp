import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: unused_import
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
/*   void initState() {
    final coinBloC = context.read<CoinBlockProvider>();
    coinBloC.add(CoinListInitEvent());
    super.initState();
  } */

  @override
  Widget build(BuildContext context) {
    final coinBloC = context.read<CoinBlockProvider>();
    // ignore: unused_local_variable
    Design design = Design(context);
    final List<CoinModel> coins = [];

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
            // ignore: sized_box_for_whitespace
            Container(
              height: 50.0,
              child: Center(child: Text('Header Section')),
            ),
            BlocConsumer<CoinBlockProvider, CoinState>(
              listener: (context, state) {
                if (state.coins.isNotEmpty) {
                  setState(() {
                    // ignore: avoid_print
                    print("Length of coins: ${coins.length}");
                    coins.addAll(state.coins);
                    // ignore: avoid_print
                    print("setState");
                    // ignore: avoid_print
                    print("Length of coins: ${coins.length}");
                  });
                }
              },
              builder: (context, state) {
                return Expanded(
                  child: BlocBuilder<CoinBlockProvider, CoinState>(
                    builder: (context, state) {
                      return GridView.builder(
                        itemCount:  state.coins.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Number of columns in the grid
                          crossAxisSpacing: 5.0, // Spacing between columns
                          mainAxisSpacing: 8.0, // Spacing between rows
                          childAspectRatio: 1, // Aspect ratio of each item
                        ),
                        itemBuilder: (context, index) {
                          // ignore: avoid_print
                          print("in screen YO");
                        
                          return MyStockSquareCard(
                            id: state.coins[index].id, //coins[index].id,
                            currentPrice: state.coins[index].currentPrice, //coins[index].currentPrice,
                            image: state.coins[index].image,
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
