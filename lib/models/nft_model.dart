class NFTModel {
  String id;
  String contractAddress;
  String assetPlatformId;
  String name;
  String symbol;
  String description;
  String nativeCurrency;
  String nativeCurrencySymbol;
  String bannerImage;
  Map<String, String> image;
  double floorPriceInNativeCurrency;
  double floorPriceInUSD;
  double marketCapInNativeCurrency;
  double marketCapInUSD;
  double volume24hInNativeCurrency;
  double volume24hInUSD;
  double oneDayAverageSalePrice;
  String homepage;
  String twitter;
  String discord;
  int totalSupply;
  int oneDaySales;
  int numberOfUniqueAddresses;
  double athNativeCurrency;
  double athUSD;
  String athDateNativeCurrency;
  String athDateUSD;

  NFTModel({
    required this.id,
    required this.contractAddress,
    required this.assetPlatformId,
    required this.name,
    required this.symbol,
    required this.description,
    required this.nativeCurrency,
    required this.nativeCurrencySymbol,
    required this.bannerImage,
    required this.image,
    required this.floorPriceInNativeCurrency,
    required this.floorPriceInUSD,
    required this.marketCapInNativeCurrency,
    required this.marketCapInUSD,
    required this.volume24hInNativeCurrency,
    required this.volume24hInUSD,
    required this.oneDayAverageSalePrice,
    required this.homepage,
    required this.twitter,
    required this.discord,
    required this.totalSupply,
    required this.oneDaySales,
    required this.numberOfUniqueAddresses,
    required this.athNativeCurrency,
    required this.athUSD,
    required this.athDateNativeCurrency,
    required this.athDateUSD,
  });

  factory NFTModel.fromJson(Map<String, dynamic> json) {
    return NFTModel(
      id: json['id'],
      contractAddress: json['contract_address'],
      assetPlatformId: json['asset_platform_id'],
      name: json['name'],
      symbol: json['symbol'],
      description: json['description'],
      nativeCurrency: json['native_currency'],
      nativeCurrencySymbol: json['native_currency_symbol'],
      bannerImage: json['banner_image'],
      image: {
        'small': json['image']['small'],
        'small_2x': json['image']['small_2x'],
      },
      floorPriceInNativeCurrency: json['floor_price']['native_currency'],
      floorPriceInUSD: json['floor_price']['usd'],
      marketCapInNativeCurrency: json['market_cap']['native_currency'],
      marketCapInUSD: json['market_cap']['usd'],
      volume24hInNativeCurrency: json['volume_24h']['native_currency'],
      volume24hInUSD: json['volume_24h']['usd'],
      oneDayAverageSalePrice: json['one_day_average_sale_price'],
      homepage: json['links']['homepage'],
      twitter: json['links']['twitter'],
      discord: json['links']['discord'],
      totalSupply: json['total_supply'],
      oneDaySales: json['one_day_sales'],
      numberOfUniqueAddresses: json['number_of_unique_addresses'],
      athNativeCurrency: json['ath']['native_currency'],
      athUSD: json['ath']['usd'],
      athDateNativeCurrency: json['ath_date']['native_currency'],
      athDateUSD: json['ath_date']['usd'],
    );
  }
}
