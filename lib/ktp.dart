import 'package:hive/hive.dart';

part 'ktp.g.dart';

@HiveType(typeId: 0)
class ktp extends HiveObject{
  @HiveField(0)
  String nama;

  @HiveField(1)
  String ttl;

  @HiveField(2)
  String kabupaten;

  @HiveField(3)
  String provinsi;

  @HiveField(4)
  String pekerjaan;

  @HiveField(5)
  String pendidikan;

  ktp({required this.nama,required this.ttl,required this.kabupaten,
       required this.provinsi,required this.pekerjaan,required this.pendidikan});
}