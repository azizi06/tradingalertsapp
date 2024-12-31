enum StockAlertType {
  priceOver,
  priceBelow,
  change24HOver,
  change24HBelow,
}

/// Represents a price alert for a specific cryptocurrency.
class AlertModel {
  /// The unique identifier of the cryptocurrency.
  final String coinID;

  /// The type of stock alert.
  final StockAlertType type;

  /// The current price of the cryptocurrency.
  final double coinPrice;

  /// The target value for triggering the alert.
  final double value;

  /// Indicates if the alert has been notified to the user.
  final bool isNotified;

  /// The Firebase Cloud Messaging token for notifications.
  final String fcmToken;

  final DateTime createdAt;
  AlertModel({
    required this.coinID,
    required this.type,
    required this.coinPrice,
    required this.value,
    required this.createdAt,
    required this.fcmToken,
    required this.isNotified,
  });

  /// Converts the model to a JSON format for storage or networking.
  Map<String, dynamic> toJson() => {
        'coinID': coinID,
        'type': type.toString().split('.').last,
        'coinPrice': coinPrice,
        'value': value,
        'isNotified': isNotified,
        'fcmToken': fcmToken,
        'createdAt': createdAt.toIso8601String(),
      };

  /// Creates an instance of AlertModel from a JSON object.
  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      coinID: json['coinID'],
      type: StockAlertType.values
          .firstWhere((e) => e.toString().split('.').last == json['type']),
      coinPrice: json['coinPrice'],
      value: json['value'],
      fcmToken: json['fcmToken'],
      isNotified: json['isNotified'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
