import 'package:flutter/material.dart';
import 'package:music_player/ui/main_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    //wait for 3 seconds before navigating to the next page
    Future.delayed(Duration(seconds: 5)).then((_) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Image.asset(
              'assets/bg.jpg',
              fit: BoxFit.cover,
              height: deviceSize.height,
              width: deviceSize.width,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Music Player',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
