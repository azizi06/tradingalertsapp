import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:stocksalertapp/models/alert_model.dart';
import 'package:stocksalertapp/services/firestore_service.dart';
import 'package:stocksalertapp/services/notification_service.dart';
import 'package:workmanager/workmanager.dart';

class BackgroundTaskManager {
  void initialize() {
    Workmanager().initialize(_callbackDispatcher, isInDebugMode: true);
    Workmanager().registerPeriodicTask(
      'checkAlertsTask',
      'checkAlerts',
      frequency: const Duration(minutes: 15),
      initialDelay: Duration(seconds: 60),
    );
  }

  static void _callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      debugPrint("Cheking Alerts ... ");


      List<AlertModel> snapshot = [];
      AlertService alertService = AlertService();

      try {
        NotificationService notificationService = NotificationService();
        if (FirebaseAuth.instance.currentUser != null) {
          final String uid = FirebaseAuth.instance.currentUser?.uid ?? "";
          print('Retrieved uid Token: $uid');
          print("Getting Alerts...");

          

           List<AlertModel> AllAlerts =
              await alertService.fetchAlertsByToken(uid);
          for (AlertModel alert in AllAlerts) {
            if (alert.isNotified == false) {
              snapshot.add(alert);
            }
          }


        }

        for (AlertModel alert in snapshot) {
          final coinID = alert.coinID;
          final value = alert.value;

          if (coinID != null && value != null) {
            final data = await fetchPrice(coinID);





            if (data != null) {
              final price = data['price'];
              final change24H = data['price_change_percentage_24h'];

              switch (alert.type) {
                case AlertType.priceOver:
                  if (price > value) {
                    print(
                        'Alert! Coin ID: $coinID price is over \$${value}. Current price: \$${price}');
                    await notificationService.showNotification("Trading Alerts",
                        " $coinID price is over \$${value}. Current price: \$${price}");
                  }
                  if (alert.documentId != null) {
                    alertService.updateIsNotified(alert.documentId ?? "");
                  }
                  break;
                case AlertType.priceBelow:
                  if (price < value) {
                    print(
                        'Alert! Coin ID: $coinID price is below \$${value}. Current price: \$${price}');
                    await notificationService.showNotification("Trading Alerts",
                        " $coinID price is below \$${value}. Current price: \$${price}");
                  }
                  if (alert.documentId != null) {
                    alertService.updateIsNotified(alert.documentId ?? "");
                  }
                  break;
                case AlertType.change24HOver:
                  if (change24H > value) {
                    print(
                        'Alert! Coin ID: $coinID 24H change is over ${value}%. Current change: ${change24H}%');
                    await notificationService.showNotification("Trading Alerts",
                        " $coinID 24H change is over ${value}%. Current change: ${change24H}%");
                  }
                  if (alert.documentId != null) {
                    alertService.updateIsNotified(alert.documentId ?? "");
                  }
                  break;
                case AlertType.change24HBelow:
                  if (change24H < value) {
                    print(
                        'Alert! Coin ID: $coinID 24H change is below ${value}%. Current change: ${change24H}%');
                    await notificationService.showNotification("Trading Alerts",
                        " $coinID 24H change is below ${value}%. Current change: ${change24H}%");
                  }
                  if (alert.documentId != null) {
                    alertService.updateIsNotified(alert.documentId ?? "");
                  }
                  break;
              }
            }
          }
        }
      } catch (e) {
        print('Error checking alerts: $e');
        debugPrint("Error checking alerts: $e");
        return Future.error("Error checking alerts: $e");
      }

      return Future.value(true);
    });
  }
}

Future<Map<String, dynamic>?> fetchPrice(String coinID) async {
  final apiUrl =
      'https://api.coingecko.com/api/v3/simple/price?ids=$coinID&vs_currencies=usd&include_price_change_percentage_24h=true';
  final dio = Dio();

  try {
    final response = await dio.get(apiUrl);

    if (response.statusCode == 200) {
      final data = response.data;
      if (data.containsKey(coinID)) {
        return {
          'price': data[coinID]['usd'],
          'price_change_percentage_24h': data[coinID]
              ['price_change_percentage_24h']
        };
      }
    } else {
      print('Error fetching price: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching price: $e');
  }

  return null;
}

Future<void> updateIsNotified(String alertId) async {
  try {
    // Reference the document by its unique ID (alertId)
    DocumentReference alertDoc = FirebaseFirestore.instance
        .collection('alerts') // Replace with your Firestore collection name
        .doc(alertId);

    // Update the isNotified field to true
    await alertDoc.update({
      'isNotified': true,
    });

    print("isNotified updated to true for alertId: $alertId");
  } catch (e) {
    print("Error updating isNotified: $e");
  }
}



Future<Map<String, dynamic>?> getCoinPriceById(String coinID) async {
  print("getting price from json");
  try {
    // Load the JSON string from the assets
    final String jsonString =
        await rootBundle.loadString('assets/data/market.json');

    // Decode the JSON string into a Dart object
    final List<dynamic> jsonData = jsonDecode(jsonString);

    // Ensure the JSON data is a list of maps
    final List<Map<String, dynamic>> data =
        List<Map<String, dynamic>>.from(jsonData);

    // Search for the coin with the given ID
    final coin = data.firstWhere(
      (coin) => coin['id'] == coinID,
      orElse: () => {},
    );

    if (coin != {}) {
      return {
        'price': coin['current_price'],
        'price_change_percentage_24h': coin['price_change_percentage_24h'],
      };
    } else {
      print('Coin with ID $coinID not found.');
    }
  } catch (e) {
    print('Error getting coin price: $e');
  }
  return null;
}
