import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_map/data/src/local.dart';
import 'package:yandex_map/presantation/bloc/open_camera/open_camera_bloc.dart';
import 'package:yandex_map/presantation/pages/map/map_screen.dart';
import 'package:yandex_map/presantation/pages/open_camera/open_camera_page.dart';

import '../../bloc/map_bloc/map_bloc.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    _navigateToNextPage();
    super.initState();
  }

  void _navigateToNextPage() {
    Timer(Duration(seconds: 3), () {
      if (SharedPrefsManager().isUser()) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => MapBloc()..add(LoadMapEvent()),
            child: MapScreen(),
          ),
        ));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (c) => BlocProvider(
            create: (context) => OpenCameraBloc(),
            child: OpenCameraPage(),
          ),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0077b6),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/img_1.png', width: 150, height: 150),
            SizedBox(height: 20),
            const Text('My Location ', style: TextStyle(color: Colors.white, fontSize: 36)),
            SizedBox(height: 10),
            Text('Loading...', style: TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
