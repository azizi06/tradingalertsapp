import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          height: myHeight,
          width: myWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // صورة متحركة أو شعار التطبيق
              Image.asset('assets/image/1.gif'),
              
              // نصوص ترحيبية
              Column(
                children: [
                  Text(
                    'The Future',
                    style: TextStyle(
                      fontSize: 50, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    'Learn more about cryptocurrency, look to',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey
                    ),
                  ),
                  Text(
                    'the future in IO Crypto',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.normal,
                      color: Colors.grey
                    ),
                  ),
                ],
              ),
              
              // زر الانتقال إلى صفحة تسجيل الدخول
              Padding(
                padding: EdgeInsets.symmetric(horizontal: myWidth * 0.1),
                child: GestureDetector(
                  onTap: () {
                    // الانتقال إلى صفحة تسجيل الدخول
                    context.go('/login');
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xffFBC700),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: myWidth * 0.05, 
                        vertical: myHeight * 0.013
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'CREATE PORTFOLIO',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 10),
                          RotationTransition(
                            turns: AlwaysStoppedAnimation(310 / 310),
                            child: Icon(Icons.arrow_forward_ios_rounded),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
