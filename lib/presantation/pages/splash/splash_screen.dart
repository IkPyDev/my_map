import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_map/presantation/pages/home/home.dart';
import 'package:yandex_map/presantation/pages/login/login.dart';

import '../../../data/src/local.dart';
import '../../bloc/home/home_bloc.dart';
import '../../bloc/login/login_bloc.dart';

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
      if(SharedPrefsManager.getUserData().username == "") {
        print(SharedPrefsManager().getUser().isNotEmpty);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    BlocProvider(
                      create: (context) => HomeBloc()..add(LoadContactsEvent()),
                      child: Home(),
                    )));
      } else
       {
         print("${SharedPrefsManager.getUserData().username} data is empty");

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => BlocProvider(
                    create: (context) => LoginBloc(),
                    child: Login(),
                  )));
      }
      /*if (SharedPrefsManager().isUser()) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => RegisterBloc(),
            child: Register(),
          ),
        ));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (c) => BlocProvider(
            create: (context) => RegisterBloc(),
            child: Register(),
          ),
        ));
      }*/
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
