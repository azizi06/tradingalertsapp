import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stocksalertapp/helpers/routes.dart';

class MyBottomAppBar extends StatelessWidget {
  const MyBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return  BottomAppBar(
          height: 65,
          shape:const  CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(onPressed: () => context.pushNamed(Routes.routeMyHomePage), icon: Icon(Icons.home,)),
              IconButton(onPressed: () => context.goNamed(Routes.routeExplore), icon: Icon(Icons.search_rounded)),
              IconButton(onPressed: () => context.pushNamed(Routes.routeFavourite), icon: Icon(Icons.heart_broken_outlined)),
              IconButton(onPressed: () => context.pushNamed(Routes.routeAlarm), icon: Icon(Icons.alarm)),
              IconButton(onPressed: () => context.pushNamed(Routes.routeSettings), icon: Icon(Icons.heart_broken,)),
            ],
          ),
        );
  }
}