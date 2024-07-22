// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_model_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContactModelHiveAdapter extends TypeAdapter<ContactModelHive> {
  @override
  final int typeId = 0;

  @override
  ContactModelHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ContactModelHive(
      id: fields[0] as int,
      name: fields[1] as String,
      number: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ContactModelHive obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.number);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContactModelHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}