import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stocksalertapp/helpers/routes.dart';
import 'package:stocksalertapp/screens/explore_screen.dart';
import 'package:stocksalertapp/screens/home_screen.dart';
import 'package:stocksalertapp/screens/test_screen.dart';



final GoRouter _router = GoRouter(
   routes: [ 
    GoRoute( 
      path: '/', 
      name: Routes.routeHome, 
      builder: (context, state) => MyHomePage(),
      ),
    GoRoute( 
      path: '/explore', 
      name: Routes.routeExplore, 
      builder: (context, state) => MyExplorePage(), ),
    GoRoute( 
      path: '/test', 
      name: "test", 
      builder: (context, state) => MyTestPage(), ),
    //GoRoute( path: '/login', name: Routes.routeLogin, builder: (context, state) => LoginPage(), ),
    //GoRoute( path: '/signup', name: Routes.routeSignUp, builder: (context, state) => SignupPage(), ),
   ], 
  );

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
       
        useMaterial3: true,
      ),
      home: MyHome()
    );
  }
}

