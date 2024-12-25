import 'package:flutter/material.dart';

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
