import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:stocksalertapp/components/my_button.dart';
import 'package:stocksalertapp/helpers/design.dart';
import 'package:stocksalertapp/helpers/routes.dart';
import 'package:stocksalertapp/models/theme_enum.dart';
import 'package:stocksalertapp/services/notification_service.dart';
import 'package:stocksalertapp/state_management/theme_bloc/theme_bloc_provider.dart';
import 'package:stocksalertapp/state_management/theme_bloc/theme_event.dart';

class MySettingsPage extends StatefulWidget {
  const MySettingsPage({super.key});

  @override
  State<MySettingsPage> createState() => _MySettingsPageState();
}

class _MySettingsPageState extends State<MySettingsPage> {
  // Parameters for theme and language
  String _selectedLanguage = 'English';
  bool _isDarkTheme = false;
  double _rateUse = 0.5;

  @override
  Widget build(BuildContext context) {
    NotificationService notificationService = NotificationService();
    Design design = Design(context);
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: design.onSurface,
        title: Text(
          "Account",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildAccountHeader(design),
          const SizedBox(height: 20),
          // Language selection
          _buildLanguageSelector(design),
          const Divider(),
          // Theme toggle
          _buildThemeToggle(design),
          const Divider(),
          // Rate use slider
          _buildRateUseSlider(design),
          // Add more settings here...
          SizedBox(
            height: 200,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SizedBox(
                width: 350,
                child: MyButton(
                    onPressed: () async {
                      await notificationService.showNotification(
                          "Tradding Alerts", "Welcome to our App");
                    },
                    text: "Show Notification",
                    color: design.error),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SizedBox(
                width: 350,
                child: MyButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      context.goNamed(Routes.routeLogin);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('logged out successfully!')),
                      );
                    },
                    text: "Logout",
                    color: design.error),
              ),
            ),
          ),
          
        ]),
      ),
    ));
  }

  Widget _buildAccountHeader(Design design) {
    return ClipPath(
      clipper: MyCustomCurvedEdges(),
      child: Container(
        color: design.onSurface,
        child: SizedBox(
          height: 150,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: design.primary,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                    width: 15,
                  ),
                  const Text(
                    " Mohammed",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSelector(Design design) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Language",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          DropdownButton<String>(
            value: _selectedLanguage,
            items: const [
              DropdownMenuItem(value: 'English', child: Text('English')),
              //DropdownMenuItem(value: 'French', child: Text('French')),
              //DropdownMenuItem(value: 'Spanish', child: Text('Spanish')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedLanguage = value!;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildThemeToggle(Design design) {
    final themeBloc = context.read<ThemeBlocProvider>();

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Dark Theme",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          Switch(
            value: _isDarkTheme,
            onChanged: (value) {
              setState(() {
                _isDarkTheme = value;
                if (_isDarkTheme) {
                  themeBloc.add(ThemeChangeEvent(ThemeType.dark));
                } else {
                  themeBloc.add(ThemeChangeEvent(ThemeType.light));
                }
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRateUseSlider(Design design) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Rate Us",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
          Slider(
            value: _rateUse,
            min: 0.0,
            max: 1.0,
            divisions: 10,
            label: (_rateUse * 100).toStringAsFixed(0) + '%',
            onChanged: (value) {
              setState(() {
                _rateUse = value;
              });
            },
          ),
        ],
      ),
    );
  }
}

class MyCustomCurvedEdges extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Start at the bottom-left corner
    path.lineTo(0, size.height);

    // First curve
    final firstCurveStart = Offset(0, size.height - 20);
    final firstCurveEnd = Offset(size.width / 3, size.height - 20);
    path.quadraticBezierTo(
      firstCurveStart.dx,
      firstCurveStart.dy,
      (firstCurveStart.dx + firstCurveEnd.dx) / 2,
      (firstCurveStart.dy + firstCurveEnd.dy) / 2,
    );

    // Second curve
    final secondCurveStart = Offset(size.width / 3, size.height - 20);
    final secondCurveEnd = Offset(size.width * 2 / 3, size.height - 20);
    path.quadraticBezierTo(
      secondCurveStart.dx,
      secondCurveStart.dy,
      (secondCurveStart.dx + secondCurveEnd.dx) / 2,
      (secondCurveStart.dy + secondCurveEnd.dy) / 2,
    );

    // Third curve
    final thirdCurveStart = Offset(size.width * 2 / 3, size.height - 20);
    final thirdCurveEnd = Offset(size.width, size.height);
    path.quadraticBezierTo(
      thirdCurveStart.dx,
      thirdCurveStart.dy,
      thirdCurveEnd.dx,
      thirdCurveEnd.dy,
    );

    // Close the path at the top-right corner
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true; // Reclip the path when the widget updates
  }
}
