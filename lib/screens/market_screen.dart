import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksalertapp/components/my_stockSquareCard.dart';
import 'package:stocksalertapp/helpers/design.dart';

import 'package:stocksalertapp/models/coin_model.dart';
import 'package:stocksalertapp/state_management/coin_block/coin_block_provider.dart';
import 'package:stocksalertapp/state_management/coin_block/coin_state.dart';

class MarketScreen extends StatefulWidget {
  final List<CoinModel> coins;

  const MarketScreen({super.key,required this.coins});
  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  @override
  Widget build(BuildContext context) {
    final coinBloC = context.read<CoinBlockProvider>();

    Design design = Design(context);
   // final List<CoinModel> coins = [];

    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 18,
            ),
            Text(
              'Coins',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.start,
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),

     
           Expanded(
              child:  GridView.builder(
                    itemCount: widget.coins.length,
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
                        id: widget.coins[index].id, //coins[index].id,
                        currentPrice: widget.coins[index]
                            .currentPrice, //coins[index].currentPrice,
                        image: widget.coins[index].image,
                        priceColor: (widget.coins[index].priceChange24h >= 0)
                            ? Colors.green
                            : Colors.red,
                      );
                    }
                  )
              
              
            )
          
      
      ],
    );
  }
}
