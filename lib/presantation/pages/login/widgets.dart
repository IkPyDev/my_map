import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_map/presantation/pages/home/home.dart';

import '../../bloc/home/home_bloc.dart';
import '../../bloc/login/login_bloc.dart';

class LoginTextField extends StatelessWidget {
  const LoginTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return TextField(
          decoration: InputDecoration(
            labelText: 'Username',
            border: const OutlineInputBorder(),
            errorText: state.login.isEmpty && state.status == LoginStatus.fail ? 'Please enter a username' : null,
            errorBorder:
                state.status == LoginStatus.fail ? OutlineInputBorder(borderSide: BorderSide(color: Colors.red)) : null,
          ),
          onChanged: (value) => context.read<LoginBloc>().add(LoginChangeLoginEvent(login: value)),
        );
      },
    );
  }
}

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({Key? key}) : super(key: key);

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return TextField(
          obscureText: _isObscure,
          decoration: InputDecoration(
            labelText: 'Password',
            border: const OutlineInputBorder(),
            errorText: state.password.isEmpty && state.status == LoginStatus.fail ? 'Please enter a password' : null,
            errorBorder:
                state.status == LoginStatus.fail ? OutlineInputBorder(borderSide: BorderSide(color: Colors.red)) : null,
            suffixIcon: IconButton(
              icon: Icon(
                _isObscure ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              },
            ),
          ),
          onChanged: (value) => context.read<LoginBloc>().add(PasswordChangeLoginEvent(password: value)),
        );
      },
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status == LoginStatus.success) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => BlocProvider(
                      create: (context) => HomeBloc()..add(LoadContactsEvent()),
                      child: const Home(),
                    )),
          );
        } else if (state.status == LoginStatus.fail && (state.login.isNotEmpty || state.password.isNotEmpty)) {
          state.status = LoginStatus.initial;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Incorrect username or password')),
          );
        }
      },
      builder: (context, state) {
        return state.status == LoginStatus.loading
            ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              )
            : InkWell(
                onTap: () {
                  if (context.read<LoginBloc>().state.login.isEmpty ||
                      context.read<LoginBloc>().state.password.isEmpty) {
                    context.read<LoginBloc>().add(NextButtonLoginEvent());
                  } else {
                    context.read<LoginBloc>().add(NextButtonLoginEvent());
                  }
                },
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text(
                      "Login",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              );
      },
    );
  }
}
