import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:yandex_map/data/src/remote/firebase_manager.dart';
import 'package:yandex_map/presantation/pages/map/map_screen.dart';
import 'package:yandex_map/presantation/pages/map_detail/map_page.dart';


import '../../../model/user_model.dart';
import '../../bloc/home/home_bloc.dart';
import '../../bloc/map/map_page_bloc.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: (){

          

        }, icon: Icon(Icons.search))],
      ),
      body: StreamBuilder<List<UserModel>>(
        stream: FirebaseManager.getAllUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No users found'));
          } else {
            var users = snapshot.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                var user = users[index];
                return ListTile(
                  leading: CachedNetworkImage(
                    imageUrl: user.imageUrl,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  title: Text(user.username), // assuming UserModel has a 'name' field
                  subtitle: Text(user.email),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MapPage(user: user,),

                      ),
                    );
                  },
                  // assuming UserModel has an 'email' field


                );
              },
            );
          }
        },
      ),
    );
  }
}
