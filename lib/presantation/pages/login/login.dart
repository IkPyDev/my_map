import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_map/presantation/pages/login/widgets.dart';

import '../../bloc/register/register_bloc.dart';
import '../register/register.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset("assets/login.png",height: 200,width: 200,),
              const SizedBox(height: 20),
              const LoginTextField(),
              const SizedBox(height: 20),
              const PasswordTextField(),
              const SizedBox(height: 20),
              const LoginButton(),
              const SizedBox(height: 20),
              SignUpLink(),
            ],
          ),
        ),
      ),
    );
  }
}

class SignUpLink extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (BuildContext context) => RegisterBloc(),
              child: const Register(),
            ),
          ),
        );
      },
      child: RichText(
        text: const TextSpan(
          text: "Don’t have an account yet?  ",
          children: [
            TextSpan(
              text: 'Sign up here',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
