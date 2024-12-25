import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stocksalertapp/helpers/routes.dart';

class MyStockSquareCard extends StatelessWidget {
  final String id;
  final double currentPrice;
  final String image;
  final Color priceColor;

  const MyStockSquareCard({
    super.key,
    required this.id,
    required this.image,
    required this.currentPrice,
    required this.priceColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: InkWell(
        onTap: () => context.pushNamed(Routes.routeCoinChart,queryParameters:{"coinID" : id}),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
            side: BorderSide(
              color: Theme.of(context).colorScheme.primary,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                backgroundImage: NetworkImage(image),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  id,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  currentPrice.toString() + " USD",
                  style:  TextStyle(
                    color:  priceColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
