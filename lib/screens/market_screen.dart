import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksalertapp/components/my_stockSquareCard.dart';
import 'package:stocksalertapp/helpers/design.dart';
import 'package:stocksalertapp/models/coinModal.dart';
import 'package:stocksalertapp/state_management/coin_block/coin_block_provider.dart';
import 'package:stocksalertapp/state_management/coin_block/coin_state.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  @override
  Widget build(BuildContext context) {
     final coinBloC = context.read<CoinBlockProvider>();
 
    Design design = Design(context);
    final List<CoinModel> coins = [];

    return  Column(
                children: [
               
                 Row(
                   children: [
                    SizedBox(width: 18,),
                     Text('Coins',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w600,),textAlign: TextAlign.start,),
                   ],
                 ),
                 SizedBox(height: 10,),
                  
                  BlocConsumer<CoinBlockProvider, CoinState>(
                    listener: (context, state) {
                      if (state.coins.isNotEmpty) {
                        setState(() {
                          // ignore: avoid_print
                          print("Length of coins: ${coins.length}");
                          coins.addAll(state.coins as Iterable<CoinModel>);
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
                                  priceColor: (state.coins[index].priceChange24h >= 0)? Colors.green : Colors.red,
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              );
  }
}