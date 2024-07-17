import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yandex_map/util/app_lat_long.dart';
import 'package:yandex_map/util/location_service.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../../model/user_model.dart';
import '../../bloc/map_bloc/map_bloc.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final mapControllerCompleter = Completer<YandexMapController>();
  final List<MapObject> mapObjects = [];

  Future<void> _moveToCurrentLocation(double lat, double lon) async {
    try {
      final controller = await mapControllerCompleter.future;
      controller.moveCamera(
        animation: const MapAnimation(type: MapAnimationType.linear, duration: 1),
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: Point(
              latitude: lat,
              longitude: lon,
            ),
            zoom: 15,
          ),
        ),
      );
    } catch (e) {
      print("Error moving camera: $e");
    }
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
    _moveToCurrentLocation(location.lat, location.long);
  }

  Future<BitmapDescriptor> _getMarkerIcon(String url) async {
    final response = await HttpClient().getUrl(Uri.parse(url));
    final bytes = await response.close().then((response) =>
        response.fold<Uint8List>(Uint8List(0),
                (previous, current) => Uint8List.fromList(previous + current)));
    return BitmapDescriptor.fromBytes(bytes); // Adjust the size as needed
  }

  Future<void> _updateMapObjects(List<UserModel> users) async {
    final newMapObjects = <MapObject>[];
    for (var user in users) {
      final icon = await _getMarkerIcon(user.imageUrl);
      newMapObjects.add(PlacemarkMapObject(
        onTap: (mapObject, point) {

        },
        text: PlacemarkText(text: user.name, style: PlacemarkTextStyle(color: Colors.black, offsetFromIcon: true)),
        mapId: MapObjectId(user.id),
        icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
            scale: 0.8,
            image: icon,
          ),
        ),
        point: Point(
          latitude: user.userLocation.lat,
          longitude: user.userLocation.lon,
        ),
      ));
    }
    setState(() {
      mapObjects.clear();
      mapObjects.addAll(newMapObjects);
    });
  }

  @override
  void initState() {
    _initPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocConsumer<MapBloc, MapState>(
          listener: (context, state) {
            if (state.users.isNotEmpty) {
              _updateMapObjects(state.users);
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                YandexMap(
                  scrollGesturesEnabled: true,

                  onMapCreated: (controller) {
                    mapControllerCompleter.complete(controller);
                  },

                  zoomGesturesEnabled: true,
                  mapObjects: mapObjects,
                ),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (c, i) {
                      return GestureDetector(
                        onTap: () async {
                          await _moveToCurrentLocation(
                            state.users[i].userLocation.lat,
                            state.users[i].userLocation.lon,
                          );
                          final icon = await _getMarkerIcon(state.users[i].imageUrl);
                          setState(() {
                            mapObjects.clear();
                            mapObjects.add(PlacemarkMapObject(
                              onTap: (mapObject, point) {
                                print('Tapped on ${state.users[i].name}');
                              },
                              mapId: MapObjectId(state.users[i].id),
                              icon: PlacemarkIcon.single(
                                PlacemarkIconStyle(
                                  scale: 0.8,
                                  image: icon,
                                ),
                              ),
                              point: Point(
                                latitude: state.users[i].userLocation.lat,
                                longitude: state.users[i].userLocation.lon,
                              ),
                            ));
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white54,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.all(10),
                          height: 80,
                          width: 80,
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  state.users[i].imageUrl,
                                  fit: BoxFit.cover,
                                  height: 50,
                                  width: 50,
                                ),
                              ),
                              Text(
                                state.users[i].name,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: state.users.length,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
