import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Item extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  var item;
  // ignore: use_key_in_widget_constructors
  Item({this.item});

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: myWidth * 0.06, vertical: myHeight * 0.02),
      // ignore: avoid_unnecessary_containers
      child: Container(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              // ignore: sized_box_for_whitespace
              child: Container(
                  height: myHeight * 0.05, child: Image.network(item.image)),
            ),
            SizedBox(
              width: myWidth * 0.02,
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.id,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    // ignore: prefer_interpolation_to_compose_strings
                    '0.4 ' + item.symbol,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: myWidth * 0.01,
            ),
            Expanded(
              flex: 2,
              // ignore: sized_box_for_whitespace
              child: Container(
                height: myHeight * 0.05,
                // width: myWidth * 0.2,
                child: Sparkline(
                  data: item.sparklineIn7D.price,
                  lineWidth: 2.0,
                  lineColor: item.marketCapChangePercentage24H >= 0
                      ? Colors.green
                      : Colors.red,
                  fillMode: FillMode.below,
                  fillGradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: const [0.0, 0.7],
                      colors: item.marketCapChangePercentage24H >= 0
                          ? [Colors.green, Colors.green.shade100]
                          : [Colors.red, Colors.red.shade100]),
                ),
              ),
            ),
            SizedBox(
              width: myWidth * 0.04,
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    // ignore: prefer_interpolation_to_compose_strings
                    '\$ ' + item.currentPrice.toString(),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Text(
                        item.priceChange24H.toString().contains('-')
                            // ignore: prefer_interpolation_to_compose_strings
                            ? "-\$" +
                                item.priceChange24H
                                    .toStringAsFixed(2)
                                    .toString()
                                    .replaceAll('-', '')
                            // ignore: prefer_interpolation_to_compose_strings
                            : "\$" + item.priceChange24H.toStringAsFixed(2),
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey),
                      ),
                      SizedBox(
                        width: myWidth * 0.03,
                      ),
                      Text(
                        item.marketCapChangePercentage24H.toStringAsFixed(2) +
                            '%',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: item.marketCapChangePercentage24H >= 0
                                ? Colors.green
                                : Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
