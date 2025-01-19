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
        final fetchedData = await fetchCoins();

        if (fetchedData.isNotEmpty && fetchedData is List) {
          for (var item in fetchedData) {
            coins.add(CoinModel.fromJson(item));
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

    on<CoinSortEvent>((event, emit) async {
      CoinSortingMethod method = event.method;
      List<CoinModel> coins = state.coins;
      try {
        List<CoinModel> sortedCoins = _onSortCoins(method, coins);
        emit(CoinState(coins: sortedCoins));
      } catch (e) {
        print('Error loading data: $e');
        emit(CoinState(coins: coins));
      }
    });
  }

  Future<List<dynamic>> fetchCoins() async {
    final dio = Dio();
    print("Fetching Data From CoinGecko");
    try {
      final response = await dio.get(
      'https://api.coingecko.com/api/v3/coins/markets',
        queryParameters: {'vs_currency': 'usd','sparkline': 'true'},
         // Add query parameters
      );

      if (response.statusCode == 200) {
        // Decode response data (Dio already decodes JSON for you)
        return response.data; // This will be a List<dynamic>
      } else {
        print('Failed to load coins. Status code: ${response.statusCode}');
        return loadJsonData();
      }
    } catch (e) {
        print('Failed to load coins. Status code: $e');
        return loadJsonData();
      /* print('Failed to load coins: $e');
      throw Exception('Failed to load coins: $e'); */
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

  List<CoinModel> _onSortCoins(
      CoinSortingMethod method, List<CoinModel> coins) {
    // Create a copy of the list to avoid modifying the original
    final sortedCoins = List<CoinModel>.from(coins);

    // Apply the sorting logic
    if (method == CoinSortingMethod.priceAsc) {
      sortedCoins.sort((a, b) => a.currentPrice.compareTo(b.currentPrice));
    } else if (method == CoinSortingMethod.priceDesc) {
      sortedCoins.sort((a, b) => b.currentPrice.compareTo(a.currentPrice));
    } else if (method == CoinSortingMethod.change24hAsc) {
      sortedCoins.sort((a, b) =>
          a.priceChangePercentage24h.compareTo(b.priceChangePercentage24h));
    } else if (method == CoinSortingMethod.change24hDesc) {
      sortedCoins.sort((a, b) =>
          b.priceChangePercentage24h.compareTo(a.priceChangePercentage24h));
    } else if (method == CoinSortingMethod.nameAsc) {
      sortedCoins.sort((a, b) => a.name.compareTo(b.name));
    } else if (method == CoinSortingMethod.nameDesc) {
      sortedCoins.sort((a, b) => b.name.compareTo(a.name));
    }

    // Return the sorted list
    return sortedCoins;
  }
}
