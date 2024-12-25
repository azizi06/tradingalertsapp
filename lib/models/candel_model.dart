class CandelModel {
  final DateTime time;
  final num? open;
  final num? close;
  final num? low;
  final num? high;
  CandelModel(
      {required this.time,
      required this.open,
      required this.close,
      required this.low,
      required this.high});

  factory CandelModel.fromJson(List l) {
    return CandelModel(
      time: DateTime.fromMillisecondsSinceEpoch(l[0])!,
      open: l[1]!,
      high: l[2]!,
      low: l[3]! ,
      close: l[4]!,
    );
  }
}
