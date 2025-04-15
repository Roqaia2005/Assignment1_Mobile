import 'package:hive/hive.dart';

part 'store.g.dart';

@HiveType(typeId: 1)
class Store extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String address;
  @HiveField(2)
  final double latitude;
  @HiveField(3)
  final double longitude;
  Store({required this.name, required this.address, required this.latitude, required this.longitude});
}
