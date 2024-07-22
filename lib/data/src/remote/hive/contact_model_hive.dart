import 'package:hive/hive.dart';

part 'contact_model_hive.g.dart';
@HiveType(typeId: 0)
class ContactModelHive extends HiveObject {

  @HiveField(0)
  int id ;

  @HiveField(1)
  String name ;

  @HiveField(2)
  String number ;

  ContactModelHive({required this.id ,required this.name,  required this.number});




}