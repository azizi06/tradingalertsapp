import 'package:flutter/material.dart';
import 'package:stocksalertapp/screens/settings_screen.dart';
import 'package:stocksalertapp/services/TimerBackgroundTaskManager.dart';
import 'package:stocksalertapp/services/background_task.dart';
import 'package:stocksalertapp/services/firebase_messaging_service.dart';
import 'package:stocksalertapp/models/coin_model.dart';
import 'package:stocksalertapp/models/theme_enum.dart';
import 'package:stocksalertapp/screens/addAlert_screen.dart';
import 'package:stocksalertapp/screens/alarm_screen.dart';
import 'package:stocksalertapp/screens/chart_screen.dart';
import 'package:stocksalertapp/services/notification_service.dart';
import 'package:stocksalertapp/state_management/coin_block/coin_block_provider.dart';
import 'package:stocksalertapp/state_management/theme_bloc/theme_bloc_provider.dart';
import 'package:stocksalertapp/state_management/theme_bloc/theme_state.dart';
import 'util.dart';
import 'theme.dart';
import 'package:go_router/go_router.dart';
import 'package:stocksalertapp/helpers/routes.dart';
import 'package:stocksalertapp/screens/explore_screen.dart';
import 'package:stocksalertapp/screens/home_screen.dart';
import 'package:stocksalertapp/screens/test_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:stocksalertapp/screens/signup_screen.dart';
import 'package:stocksalertapp/screens/login_screen.dart';
import 'package:stocksalertapp/screens/favoris_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final GoRouter _router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/' + Routes.routeSettings,
      name: Routes.routeSettings, // pour recuperer le nom du route
      builder: (context, state) => MySettingsPage(),
    ),
    GoRoute(
      path: '/' + Routes.routeMyHomePage,
      name: Routes.routeMyHomePage, // pour recuperer le nom du route
      builder: (context, state) => Home(),
    ),
    GoRoute(
      path: '/' + Routes.routeExplore,
      name: Routes.routeExplore,
      builder: (context, state) => MyExplorePage(),
    ),
    GoRoute(
      path: '/' + Routes.routeAlarm,
      name: Routes.routeAlarm,
      builder: (context, state) => AlarmPage(),
    ),
    GoRoute(
      path: "/" + Routes.routeCoinChart,
      name: Routes.routeCoinChart,
      builder: (context, state) {
        final String coinID = state.uri.queryParameters['coinID']!;
        return MyChartScreen(coinID: coinID);
      },
    ),
    GoRoute(
      path: "/" + Routes.routeAddAlert,
      name: Routes.routeAddAlert,
      builder: (context, state) {
        final String coinID = state.uri.queryParameters['coinID']!;
        final String coinImage = state.uri.queryParameters['coinImage']!;
        return MyAddalertPage(coinID: coinID, coinImage: coinImage);
      },
    ),
    GoRoute(
      path: '/test',
      name: "test",
      builder: (context, state) => MyTestPage(),
    ),
    GoRoute(
      path: '/signup',
      name: Routes.routeSignUp,
      builder: (context, state) => SignupPage(),
    ),
    GoRoute(
      path: '/login',
      name: Routes.routeLogin,
      builder: (context, state) => LoginPage(),
    ),
    GoRoute(
      path: '/favorites',
      name: Routes.routeFavourite,
      builder: (context, state) => FavouritePage(),
    ),
  ],
);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessagingService().initialize();
  NotificationService notificationService = NotificationService();
  notificationService.initializeNotifications();
 // BackgroundTaskManager().initialize();
 // TimerBackgroundTaskManager().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  //# const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    //TextTheme textTheme = Theme.of(context).textTheme;
    TextTheme textTheme = createTextTheme(context, "Roboto Flex", "Roboto");
    MaterialTheme theme = MaterialTheme(textTheme);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeBlocProvider(),
        ),
        BlocProvider(create: (context) => CoinBlockProvider()),
      ],
      child: BlocBuilder<ThemeBlocProvider, ThemeState>(
        builder: (context, state) {
          final Map<ThemeType, ThemeData> _themes = {
            ThemeType.light: theme.light(),
            ThemeType.dark: theme.dark(),
            ThemeType.lightMediumContrast: theme.lightMediumContrast(),
          };
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: _themes[state.currentTheme],
            routerConfig: _router,
          );
        },
      ),
    );
  }
}
