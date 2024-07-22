import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:yandex_map/model/user_model.dart';
import 'package:yandex_map/util/push_service.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../../data/src/remote/firebase_manager.dart';
import '../../bloc/map/map_page_bloc.dart';


class MapPage extends StatelessWidget {
   UserModel user;
   MapPage({required this.user,super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel>(
      stream: FirebaseManager.getUserByEmail(user.email),
      builder: (context,datas) {
        UserModel data = datas.data ?? UserModel.initial();
        if(datas.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator());
        }else if(datas.hasError){
          return Center(child: Text('Error: ${datas.error}'));
        }else return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text(data.username, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body:
          Column(
            children: [
              Expanded(
                child: YandexMap(
                  onMapCreated: (ctr) {
                    ctr.moveCamera(
                      animation: const MapAnimation(type: MapAnimationType.linear, duration: 1),
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: Point(
                            latitude: data.lat ,
                            longitude: data.lon,
                          ),
                          zoom: 18,
                        ),
                      ),
                    );
                  },
                  zoomGesturesEnabled: true,
                  mapObjects: [
                    PlacemarkMapObject(
                      onTap: (a, b) {},
                      mapId: MapObjectId('1'),
                      point: Point(latitude: data.lat, longitude: data.lon),
                      icon: PlacemarkIcon.single(PlacemarkIconStyle(scale: 0.2, image: BitmapDescriptor.fromAssetImage('assets/app_icon/location.png'))),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(data.username, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(data.groupId, style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    Text(data.userId, style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 8),
                    InkWell(
                      onTap: (){
                        openMap(data.lat, data.lon);
                      },
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade100),
                        ),
                        child: Wrap(
                          children: [
                            // Image.asset("assets/app_icon/location_two.png",color: Theme.of(context).primaryColor,height: 20,width: 20,),
                            SizedBox(width: 10,),
                            Text('Marhsrutni ko\'rish', style: Theme.of(context).textTheme.bodyMedium),
                            ElevatedButton(onPressed: (){
                              PushService.push(data.notificationToken, "Locatsiya Olish", "Locatsiyagini olish uchun bosing bu yerga ");

                            }, child: Text("Oxirgi locatsiyani olish ")),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ));
      }
    );
  }

}
void openMap(lat,long) async {
  try {
    await launchUrlString('https://www.google.com/maps/search/?api=1&query=$lat,$long',
        mode: LaunchMode.externalApplication);
  } catch (e) {
    debugPrint(  "🚀 catched error~ $e:");
  }
}
