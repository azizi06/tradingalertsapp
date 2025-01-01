import 'package:stocksalertapp/models/coin_model.dart';
import 'package:stocksalertapp/state_management/coin_block/coin_event.dart';

class CoinState {
  List<CoinModel> coins;

  CoinState({required this.coins});
}
