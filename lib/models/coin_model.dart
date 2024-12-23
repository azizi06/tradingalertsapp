import 'dart:convert';

class CoinModel {
  final String id;
  final String symbol;
  final String name;
  final String image;
  final double currentPrice;
  final double marketCap;
  final double marketCapRank;
  final double fullyDilutedValuation;
  final double totalVolume;
  final double high24h;
  final double low24h;
  final double priceChange24h;
  final double priceChangePercentage24h;
  final double marketCapChange24h;
  final double marketCapChangePercentage24h;
  final double circulatingSupply;
  final double totalSupply;
  final double maxSupply;
  //final double ath;
  //final double athChangePercentage;
  //final DateTime athDate;
  //final double atl;
  //final double atlChangePercentage;
  //final DateTime atlDate;
  //final String? roi; // nullable
  //final DateTime lastUpdated;

  CoinModel({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.marketCap,
    required this.marketCapRank,
    required this.fullyDilutedValuation,
    required this.totalVolume,
    required this.high24h,
    required this.low24h,
    required this.priceChange24h,
    required this.priceChangePercentage24h,
    required this.marketCapChange24h,
    required this.marketCapChangePercentage24h,
    required this.circulatingSupply,
    required this.totalSupply,
    required this.maxSupply,
    //required this.ath,
    //required this.athChangePercentage,
    //required this.athDate,
    //required this.atl,
    //required this.atlChangePercentage,
    //required this.atlDate,
    //this.roi,
    //required this.lastUpdated,
  });

  factory CoinModel.fromJson(Map<String, dynamic> json) {
    return CoinModel(
      id: json['id'],
      symbol: json['symbol'],
      name: json['name'],
      image: json['image'],
      currentPrice: (json['current_price'] as num?)?.toDouble() ?? 0.0,
      marketCap: (json['market_cap'] as num?)?.toDouble() ?? 0.0,
      marketCapRank: (json['market_cap_rank'] as num?)?.toDouble() ?? 0.0,
      fullyDilutedValuation: (json['fully_diluted_valuation'] as num?)?.toDouble() ?? 0.0,
      totalVolume: (json['total_volume'] as num?)?.toDouble() ?? 0.0,
      high24h: (json['high_24h'] as num?)?.toDouble() ?? 0.0,
      low24h: (json['low_24h'] as num?)?.toDouble() ?? 0.0,
      priceChange24h: (json['price_change_24h'] as num?)?.toDouble() ?? 0.0,
      priceChangePercentage24h: (json['price_change_percentage_24h'] as num?)?.toDouble() ?? 0.0,
      marketCapChange24h: (json['market_cap_change_24h'] as num?)?.toDouble() ?? 0.0,
      marketCapChangePercentage24h: (json['market_cap_change_percentage_24h'] as num?)?.toDouble() ?? 0.0,
      circulatingSupply: (json['circulating_supply'] as num?)?.toDouble() ?? 0.0,
      totalSupply: (json['total_supply'] as num?)?.toDouble() ?? 0.0,
      maxSupply: (json['max_supply'] != null && json['max_supply'] is num) ? (json['max_supply'] as num).toDouble() : 0.0,
      //ath: (json['ath'] as num?)?.toDouble() ?? 0.0,
      //athChangePercentage: (json['ath_change_percentage'] as num?)?.toDouble() ?? 0.0,
      //athDate: DateTime.parse(json['ath_date']),
      //atl: (json['atl'] as num?)?.toDouble() ?? 0.0,
      //atlChangePercentage: (json['atl_change_percentage'] as num?)?.toDouble() ?? 0.0,
      //atlDate: DateTime.parse(json['atl_date']),
      //roi: json['roi'],
      //lastUpdated: DateTime.parse(json['last_updated']),
    );
  }
  
    Map<String, String> toMap() {
    return {
      'id': id,
      'symbol': symbol,
      'name': name,
      'image': image,
      'currentPrice': currentPrice.toString(),
      'marketCap': marketCap.toString(),
      'marketCapRank': marketCapRank.toString(),
      'fullyDilutedValuation': fullyDilutedValuation.toString(),
      'totalVolume': totalVolume.toString(),
      'high24h': high24h.toString(),
      'low24h': low24h.toString(),
      'priceChange24h': priceChange24h.toString(),
      'priceChangePercentage24h': priceChangePercentage24h.toString(),
      'marketCapChange24h': marketCapChange24h.toString(),
      'marketCapChangePercentage24h': marketCapChangePercentage24h.toString(),
      'circulatingSupply': circulatingSupply.toString(),
      'totalSupply': totalSupply.toString(),
      'maxSupply': maxSupply.toString(),
    };
  }



}
