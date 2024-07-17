import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yandex_map/presantation/pages/map/map_screen.dart';
import 'package:yandex_map/util/snack_bar_service.dart';

import '../../../util/app_lat_long.dart';
import '../../../util/location_service.dart';
import '../../bloc/map_bloc/map_bloc.dart';
import '../../bloc/open_camera/open_camera_bloc.dart';

class OpenCameraPage extends StatefulWidget {
  const OpenCameraPage({super.key});

  @override
  State<OpenCameraPage> createState() => _OpenCameraPageState();
}

class _OpenCameraPageState extends State<OpenCameraPage> {
  final _controllerText = TextEditingController();
  Uint8List? _image;
  File? selectImage;

  String? selectImageUrl;

  @override
  void dispose() {
    _controllerText.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: BlocConsumer<OpenCameraBloc, OpenCameraState>(
            listener: (context, state) {
              if (state.status == DownloadOpenCameraState.upload) {
                showDialog(
                  context: context,
                  barrierDismissible: false, // Prevents the dialog from being dismissed by tapping outside
                  builder: (BuildContext context) {
                    return const AlertDialog(
                      title: Text('Iltimos kuting...'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 20),
                          Text('Serverga rasm yuklanmoqda...')
                        ],
                      ),
                    );
                  },
                );
              }
              if (state.status == DownloadOpenCameraState.success) {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => MapBloc()..add(LoadMapEvent()),
                      child: const MapScreen(),
                    ),
                  ),
                );
              }
              if (state.status == DownloadOpenCameraState.fail) {
                Navigator.of(context).pop(); // Close the dialog if there's an error
                SnackBarService.replaceSnackBar(context, "Upload failed. Please try again.");
              }
            },
          builder: (context, state) {
            return Column(
              children: [
                const Spacer(),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Stack(
                    children: [
                      state.image != null
                          ? CircleAvatar(radius: 100, backgroundImage: MemoryImage(_image!))
                          : const CircleAvatar(
                              radius: 100,
                              backgroundImage: AssetImage("assets/img.png"),
                            ),
                      Positioned(
                          bottom: -0,
                          left: 140,
                          child: IconButton(
                              onPressed: () {
                                showImagePickerOption(context);
                              },
                              icon: const Icon(Icons.add_a_photo)))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _controllerText,
                    decoration: InputDecoration(
                        label: const Text("Nik kiriting"), border: OutlineInputBorder(borderRadius: BorderRadius.circular(25))),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Spacer(),
                ElevatedButton(
                    onPressed: () {
                      context.read<OpenCameraBloc>().add(UploadOpenCameraEvent(name: _controllerText.text));
                    },
                    child: const Text("Saqlash")),
                const SizedBox(
                  height: 20,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void showImagePickerOption(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.white,
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
                      onTap: () {
                        _pickImageFromGallery();
                      },
                      child: const SizedBox(
                        child: Column(
                          children: [
                            Icon(
                              Icons.image,
                              size: 70,
                            ),
                            Text("Gallery")
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        _pickImageFromCamera();
                      },
                      child: const SizedBox(
                        child: Column(
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 70,
                            ),
                            Text("Camera")
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

//Gallery
  Future<void> _pickImageFromGallery() async {
    final returnImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnImage == null) return;
    // getIns();
    selectImage = File(returnImage.path);
    _image = File(returnImage.path).readAsBytesSync();
    context.read<OpenCameraBloc>().add(SelectImageOpenCameraEvent(image: _image!, selectImage: selectImage!));
    print(selectImageUrl);
    if (!context.mounted) return;
    Navigator.of(context).pop();
    setState(() {});
  }

//Camera

  Future _pickImageFromCamera() async {
    final returnImage = await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnImage == null) return;
    selectImage = File(returnImage.path);
    _image = File(returnImage.path).readAsBytesSync();
    context.read<OpenCameraBloc>().add(SelectImageOpenCameraEvent(image: _image!, selectImage: selectImage!));

    setState(() {});
    Navigator.of(context).pop();
  }

  Future<void> _initPermission() async {
    if (!await LocationService().checkPermission()) {
      await LocationService().requestPermission();
    }
    await _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    AppLatLong location;
    const defLocation = MoscowLocation();
    try {
      location = await LocationService().getCurrentLocation();
    } catch (_) {
      location = defLocation;
    }
    context
        .read<OpenCameraBloc>()
        .add(UserLocationOpenCameraEvent(UserLocation(lat: location.lat, lon: location.long)));
  }

  @override
  void initState() {
    _initPermission();
    // getBranches();
    super.initState();
  }
}
