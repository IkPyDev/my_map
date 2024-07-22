import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yandex_map/presantation/bloc/login/login_bloc.dart';

import '../../../util/app_lat_long.dart';
import '../../../util/location_service.dart';
import '../../bloc/register/register_bloc.dart';
import '../login/login.dart';

class Register extends StatelessWidget {
  const Register({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _ProfileImagePicker(),
              SizedBox(height: 20),
              _EmailInput(),
              SizedBox(height: 20),
              _UsernameInput(),
              SizedBox(height: 20),
              _PasswordInput(),
              SizedBox(height: 20),
              _ConfirmPasswordInput(),
              SizedBox(height: 20),
              _GroupSwitch(),
              SizedBox(height: 20),
              _GroupIdInput(),
              SizedBox(height: 20),
              ElevatedButton(onPressed: () => _initPermission(context), child: Text("Fetch Loacation ")),
              _RegisterButton(),
              SizedBox(height: 20),
              _LoginRedirect(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _initPermission(BuildContext context) async {
    if (!await LocationService().checkPermission()) {
      await LocationService().requestPermission();
    }
    await _fetchCurrentLocation(context);
  }

  Future<void> _fetchCurrentLocation(BuildContext context) async {
    AppLatLong location;
    const defLocation = MoscowLocation();
    try {
      location = await LocationService().getCurrentLocation();
    } catch (_) {
      location = defLocation;
    }
    print(" location ${location.lat }  ${location.long}");
    context.read<RegisterBloc>().add(LocationChanged(lat: location.lat, lon: location.long));
  }
}

class _ProfileImagePicker extends StatelessWidget {
  const _ProfileImagePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return Center(
          child: Stack(
            children: [
              state.image != null
                  ? CircleAvatar(radius: 100, backgroundImage: MemoryImage(state.image!))
                  : const CircleAvatar(
                      radius: 100,
                      backgroundImage: AssetImage("assets/img.png"),
                    ),
              Positioned(
                bottom: 0,
                left: 140,
                child: IconButton(
                  onPressed: () => _showImagePickerOption(context),
                  icon: const Icon(Icons.add_a_photo),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showImagePickerOption(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (builder) {
        return Padding(
          padding: const EdgeInsets.all(18.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 4.5,
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => _pickImage(context, ImageSource.gallery),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image, size: 70),
                        Text("Gallery"),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => _pickImage(context, ImageSource.camera),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt, size: 70),
                        Text("Camera"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      File file = File(pickedFile.path);
      context.read<RegisterBloc>().add(SelectImageRegisterEvent(image: await file.readAsBytes(), selectImage: file));
      Navigator.of(context).pop();
    }
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return TextField(
          onChanged: (username) => context.read<RegisterBloc>().add(EmailChanged(username)),
          decoration: const InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
        );
      },
    );
  }
}

class _UsernameInput extends StatelessWidget {
  const _UsernameInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return TextField(
          onChanged: (username) => context.read<RegisterBloc>().add(UsernameChanged(username)),
          decoration: const InputDecoration(
            labelText: 'Username',
            border: OutlineInputBorder(),
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return TextField(
          onChanged: (password) => context.read<RegisterBloc>().add(PasswordChanged(password)),
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
          ),
        );
      },
    );
  }
}

class _ConfirmPasswordInput extends StatelessWidget {
  const _ConfirmPasswordInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return TextField(
          onChanged: (confirmPassword) => context.read<RegisterBloc>().add(ConfirmPasswordChanged(confirmPassword)),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            border: const OutlineInputBorder(),
            errorText: state.password != state.confirmPassword ? 'Passwords do not match' : null,
          ),
        );
      },
    );
  }
}

class _GroupSwitch extends StatelessWidget {
  const _GroupSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return SwitchListTile(
          title: const Text('Join Existing Group'),
          value: state.isJoinGroup,
          activeColor: Colors.red,
          onChanged: (value) => context.read<RegisterBloc>().add(GroupSwitchChanged(value)),
        );
      },
    );
  }
}

class _GroupIdInput extends StatelessWidget {
  const _GroupIdInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        if (state.isJoinGroup) {
          return TextField(
            enabled: state.isJoinGroup,
            maxLength: 10,
            minLines: 1,
            autofocus: state.isJoinGroup,
            onChanged: (groupId) => context.read<RegisterBloc>().add(GroupIdChanged(groupId)),
            decoration: const InputDecoration(
              labelText: 'Group ID',
              border: OutlineInputBorder(),
            ),
          );
        } else {
          return TextField(
            enabled: state.isJoinGroup,
            maxLength: 10,
            minLines: 1,
            autofocus: state.isJoinGroup,
            controller: TextEditingController(text: state.groupId),
            decoration: const InputDecoration(
              labelText: 'Group ID',
              border: OutlineInputBorder(),
            ),
          );
        }
      },
    );
  }
}

class _RegisterButton extends StatelessWidget {
  const _RegisterButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      builder: (context, state) {
        return Column(
          children: [
            if (state.status == RegisterStatus.loading)
              Center(
                child: CircularProgressIndicator(),
              )
            else
              GestureDetector(
                onTap: () {
                  if (state.password == state.confirmPassword && state.selectImage != null) {
                    context.read<RegisterBloc>().add(RegisterSubmitted());
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('All fields are mandatory')),
                    );
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
                      "Register",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ),
            if (state.status == RegisterStatus.fail)
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  state.errorMessage ?? 'Registration failed',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _LoginRedirect extends StatelessWidget {
  const _LoginRedirect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (BuildContext context) => BlocProvider(
                    create: (context) => LoginBloc(),
                    child: Login(),
                  )),
        );
      },
      child: RichText(
        text: const TextSpan(
          text: "Already have an account? ",
          children: [
            TextSpan(
              text: 'Login here',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ],
          style: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
