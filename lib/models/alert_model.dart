import 'dart:ffi';

enum StockAlertType {
  priceOver,
  priceBelow,
  change24HOver,
  change24HBelow,
}

class AlertModel {
  final String coinID;
  final StockAlertType type;
  final double coinPrice; 

  AlertModel({
    required this.coinID,
    required this.type,
    required this.coinPrice,
  });
}
