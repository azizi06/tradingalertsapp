import 'package:flutter/material.dart';
import 'package:stocksalertapp/components/my_bottomAppBar.dart';
import 'package:stocksalertapp/components/my_stockSquareCard.dart';

class MyExplorePage extends StatefulWidget {
  const MyExplorePage({super.key});

  @override
  State<MyExplorePage> createState() => _MyExplorePageState();
}

class _MyExplorePageState extends State<MyExplorePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(preferredSize: Size.fromHeight(100),child: SizedBox(height: 100,),),
        bottomNavigationBar: MyBottomAppBar(),
        body: Column(
            children: [
              Container( height: 100.0,  child: Center(child: Text('Header Section')), ),
              Expanded(
                //height: 400,
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of columns in the grid
                        crossAxisSpacing: 10.0, // Spacing between columns
                        mainAxisSpacing: 10.0, // Spacing between rows
                        childAspectRatio: 3 / 2, // Aspect ratio of each item
                      ),
                      itemBuilder: (context, index) {
                        return MyStockSquareCard();
                      }))
            ],
          
        ),
      ),
    );
  }
}
