import 'package:flutter/material.dart';
import 'package:stocksalertapp/models/coin_model.dart';

abstract class CoinEvent {
  CoinEvent();
}

class CoinListInitEvent extends CoinEvent {
  CoinListInitEvent();
}

class CoinChartDataEvent extends CoinEvent {
  final String coinID;
  CoinChartDataEvent({required this.coinID});
}

class CoinSortEvent extends CoinEvent {
  final CoinSortingMethod method;
  CoinSortEvent({required this.method});

}
