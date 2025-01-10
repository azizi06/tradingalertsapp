class AlertType {
  static const String priceOver = "Price is over";
  static const String priceBelow= "Price is below";
  static const String change24HOver = "24H change is over";
  static const String change24HBelow = "24H change is below";
}

/// Represents a price alert for a specific cryptocurrency.
class AlertModel {
  /// The unique identifier of the cryptocurrency.
  final String coinID;

  /// The type of stock alert.
  final String type;

  /// The current price of the cryptocurrency.
  final double coinPrice;

  /// The target value for triggering the alert.
  final double value;

  /// Indicates if the alert has been notified to the user.
  final bool isNotified;

  /// The Firebase Cloud Messaging token for notifications.
  final String fcmToken;

  final String uid;

  final DateTime createdAt;

  String? documentId;
  AlertModel({
    required this.uid,
    required this.coinID,
    required this.type,
    required this.coinPrice,
    required this.value,
    required this.createdAt,
    required this.fcmToken,
    required this.isNotified,
    this.documentId
  });

  /// Converts the model to a JSON format for storage or networking.
  Map<String, dynamic> toJson() => {
        'uid' : uid,
        'coinID': coinID,
        'type': type,
        'coinPrice': coinPrice,
        'value': value,
        'isNotified': isNotified,
        'fcmToken': fcmToken,
        'createdAt': createdAt.toIso8601String(),
        if (documentId != null) 'documentId': documentId,
      };

  /// Creates an instance of AlertModel from a JSON object.
  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      coinID: json['coinID'],
      type: json['type'],
      coinPrice: json['coinPrice'],
      value: json['value'],
      fcmToken: json['fcmToken'],
      isNotified: json['isNotified'],
      createdAt: DateTime.parse(json['createdAt']),
      uid: json['uid'],
       //documentId: json['documentId'],
    );
  }
}
