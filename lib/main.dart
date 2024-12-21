import 'package:flutter/material.dart';
import 'util.dart';
import 'theme.dart';
import 'package:go_router/go_router.dart';
import 'package:stocksalertapp/helpers/routes.dart';
import 'package:stocksalertapp/screens/explore_screen.dart';
import 'package:stocksalertapp/screens/home_screen.dart';
import 'package:stocksalertapp/screens/test_screen.dart';



final GoRouter _router = GoRouter(
   initialLocation: '/test',
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
  @override
  Widget build(BuildContext context) {
  
    final brightness = View.of(context).platformDispatcher.platformBrightness;  
    //TextTheme textTheme = Theme.of(context).textTheme;
    TextTheme textTheme = createTextTheme(context, "Roboto Flex", "Roboto");
    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme:  theme.dark(),
      routerConfig: _router,
    );
  }
}

