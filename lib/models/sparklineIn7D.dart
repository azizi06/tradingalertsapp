class SparklineIn7D {
  SparklineIn7D({
    required this.price,
  });

  List<double> price;

  factory SparklineIn7D.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      return SparklineIn7D(
        price: List<double>.from(json["price"].map((x) => x?.toDouble())),
      );
    }
    return SparklineIn7D(price: []);
  }
  Map<String, dynamic> toJson() => {
        "price": List<dynamic>.from(price.map((x) => x)),
      };
}
