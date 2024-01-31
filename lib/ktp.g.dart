// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ktp.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ktpAdapter extends TypeAdapter<ktp> {
  @override
  final int typeId = 0;

  @override
  ktp read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ktp(
      nama: fields[0] as String,
      ttl: fields[1] as String,
      kabupaten: fields[2] as String,
      provinsi: fields[3] as String,
      pekerjaan: fields[4] as String,
      pendidikan: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ktp obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.nama)
      ..writeByte(1)
      ..write(obj.ttl)
      ..writeByte(2)
      ..write(obj.kabupaten)
      ..writeByte(3)
      ..write(obj.provinsi)
      ..writeByte(4)
      ..write(obj.pekerjaan)
      ..writeByte(5)
      ..write(obj.pendidikan);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ktpAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
