import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stocksalertapp/models/coin_model.dart';
import 'package:stocksalertapp/state_management/coin_block/coin_event.dart';
import 'package:stocksalertapp/state_management/coin_block/coin_state.dart';
import 'package:flutter/services.dart' show rootBundle;

class CoinBlockProvider extends Bloc<CoinEvent, CoinState> {
  CoinBlockProvider() : super(CoinState(coins: [])) {
    on<CoinListInitEvent>((event, emit) async {
      final List<CoinModel> coins = [];
      try {
        final fetchedData = await loadJsonData();

        if (fetchedData.isNotEmpty && fetchedData is List) {
          print(
              "------------------------------------------------------------------- DATA START ---------------------------------------------------");
          print(fetchedData);
          print("\nHooooHaaa");
          print(
              "------------------------------------------------------------------- DATA  END ---------------------------------------------------");
          int i = 0;
          for (var item in fetchedData) {
            coins.add(CoinModel.fromJson(item));
            print(i);
            i += 1;
          }
          print("emiting... ");
          emit(CoinState(coins: coins));
        } else {
          emit(CoinState(coins: []));
        }
      } catch (e) {
        print('Error loading data: $e');
        emit(CoinState(coins: []));
      }
    });
  }

  Future<List<dynamic>> fetchCoins() async {
    final dio = Dio();
    print("Fetching Data From CoinGecko");
    try {
      final response = await dio.get(
        'https://api.coingecko.com/api/v3/coins/markets',
        queryParameters: {'vs_currency': 'usd'}, // Add query parameters
      );

      if (response.statusCode == 200) {
        // Decode response data (Dio already decodes JSON for you)
        return response.data; // This will be a List<dynamic>
      } else {
        throw Exception(
            'Failed to load coins. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to load coins: $e');
      throw Exception('Failed to load coins: $e');
    }
  }

  Future<List<dynamic>> loadJsonData() async {
    // Load the JSON file
    print("Loading Data From market.json");
    try {
      final String jsonString =
          await rootBundle.loadString('assets/data/market.json');
      // Decode the JSON string into a Dart object
      final List<dynamic> jsonData = jsonDecode(jsonString);
      print(jsonData);
      return jsonData;
    } catch (e) {
      print('Error reading local JSON file: $e');
      throw Exception('Error reading local JSON file: $e');
    }
  }
}
