/* import 'package:flutter/material.dart'; 
import 'package:stocksalertapp/helpers/design.dart';

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
    Design design = Design(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: design.primary,
          title: const Text("Account"),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipPath(
                clipper: MyCustomCurvedEdges(),
                child: Container(
                  color: design.primary,
                  child: SizedBox(
                    height: 150,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                          const SizedBox(height: 10),
                          const Text(
                            "John Doe",
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
              const SizedBox(height: 20),
              // Language selection
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Language",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    DropdownButton<String>(
                      value: _selectedLanguage,
                      items: const [
                        DropdownMenuItem(value: 'English', child: Text('English')),
                        DropdownMenuItem(value: 'French', child: Text('French')),
                        DropdownMenuItem(value: 'Spanish', child: Text('Spanish')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedLanguage = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const Divider(),
              // Theme toggle
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Dark Theme",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Switch(
                      value: _isDarkTheme,
                      onChanged: (value) {
                        setState(() {
                          _isDarkTheme = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const Divider(),
              // Rate use slider
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Rate Use",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
              ),
            ],
          ),
        ),
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
 */